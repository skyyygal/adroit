import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/chats_controller.dart';

class MessagesStream extends GetView<ChatsController> {
  const MessagesStream({Key? key});

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      return const Center(
        child: Text('Please sign in to view messages.'),
      );
    }

    final currentUserUid = currentUser.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final messages = snapshot.data!.docs;
        final messageBars = <MessageBar>[];

        for (var message in messages) {
          final messageSenderUid = message['senderUid'] as String?;
          final messageSenderEmail = message['senderEmail'] as String?;
          final messageText = message['text'] as String?;

          if (messageSenderUid == currentUserUid) {
            messageBars.add(
              MessageBar(
                sender: messageSenderEmail!,
                text: messageText!,
                isMe: true,
              ),
            );
          } else {
            messageBars.add(
              MessageBar(
                sender: messageSenderEmail!,
                text: messageText!,
                isMe: false,
              ),
            );
          }
        }

        return Expanded(
          child: ListView(
            reverse: true,
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBars,
          ),
        );
      },
    );
  }
}

class MessageBar extends StatelessWidget {
  const MessageBar({
    Key? key,
    required this.sender,
    required this.text,
    required this.isMe,
  });

  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender,
            style: const TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          Material(
            borderRadius: isMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  )
                : const BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
            elevation: 5.0,
            color: isMe ? Colors.deepPurpleAccent : Colors.yellow[200],
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.yellow[200] : Colors.black54,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
