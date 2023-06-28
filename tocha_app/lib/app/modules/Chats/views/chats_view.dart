import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/chats_controller.dart';
import 'message_view.dart';

class ChatsView extends GetView<ChatsController> {
  final ChatsController _chatsController = Get.put(ChatsController());
  ChatsView({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Get.offNamed('/home'),
          ),
        ],
        title: const Text('Chat'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Expanded(child: MessagesStream()),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(width: 2.0),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _chatsController.messageTextController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        hintText: 'Type Message...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: controller.sendMessage,
                    child: const Text(
                      'Send',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
