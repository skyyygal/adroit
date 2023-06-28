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

  // void signOut() async {
  //   await _auth.signOut();
  //   await _googleSignIn.signOut();
  //   Get.offNamed('/home');
  // }

  void sendMessage() {
    try {
      final String messageText = messageTextController.text;
      messageTextController.clear();

      final user = _auth.currentUser;
      if (user != null) {
        _firestore.collection('messages').add({
          'text': messageText,
          'senderUid': user.uid,
          'senderEmail': user.email,
        });
      }
    } catch (e) {
      print('Error sending message: $e');
    }
  }
}
