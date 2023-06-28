import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

class ChatsController extends GetxController {
  final TextEditingController messageTextController = TextEditingController();
  final List<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;

  final RxString receiverName = ''.obs;
  void setReceiverName(String name) {
    receiverName.value = name;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await _auth.signInWithCredential(credential);
  }

  Future<void> startChatWithUser(String receiverId) async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      final senderId = currentUser.uid;

      final receiverDoc =
          await _firestore.collection('users').doc(receiverId).get();
      if (receiverDoc.exists) {
        final receiverData = receiverDoc.data() as Map<String, dynamic>?;
        final receiverName = receiverData?['name'] as String?;
        setReceiverName(receiverName ?? '');
      }

      // Start the chat with the specified receiver
      _firestore
          .collection('messages')
          .where('senderUid', isEqualTo: senderId)
          .where('receiverUid', isEqualTo: receiverId)
          .orderBy('timestamp', descending: true)
          .snapshots()
          .listen((snapshot) {
        final List<Map<String, dynamic>> chatMessages = [];
        for (var doc in snapshot.docs) {
          final message = doc.data();
          chatMessages.add(message);
        }
        messages.assignAll(chatMessages);
      });
    }
  }

  void sendMessage() {
    try {
      final String messageText = messageTextController.text;
      messageTextController.clear();

      final user = _auth.currentUser;
      if (user != null) {
        final senderUid = user.uid;
        final senderEmail = user.email;
        final senderName = user.displayName;

        // Replace with the actual receiver's name

        _firestore.collection('messages').add({
          'text': messageText,
          'senderUid': senderUid,
          'senderEmail': senderEmail,
          'senderName': senderName,
          'receiverName': receiverName,
          'timestamp': FieldValue.serverTimestamp(), // Include timestamp
        });
      }
    } catch (e) {
      print('Error sending message: $e');
    }

    void getChatMessages(String receiverId) {
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        final senderId = currentUser.uid;

        _firestore
            .collection('messages')
            .where('senderUid', isEqualTo: senderId)
            .where('receiverUid', isEqualTo: receiverId)
            .orderBy('timestamp', descending: true)
            .snapshots()
            .listen((snapshot) {
          final List<Map<String, dynamic>> chatMessages = [];
          for (var doc in snapshot.docs) {
            final message = doc.data();
            chatMessages.add(message);
          }
          messages.assignAll(chatMessages);
        });
      }
    }
  }

  // void sendMessage() {
  //   try {
  //     final String messageText = messageTextController.text;
  //     messageTextController.clear();

  //     final user = _auth.currentUser;
  //     if (user != null) {
  //       _firestore.collection('messages').add({
  //         'text': messageText,
  //         'senderUid': user.uid,
  //         'senderEmail': user.email,
  //         'senderName': user.displayName,
  //         'senderDP': user.photoURL
  //       });
  //     }
  //   } catch (e) {
  //     print('Error sending message: $e');
  //   }
  // }
}
