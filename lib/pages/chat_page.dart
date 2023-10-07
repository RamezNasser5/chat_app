import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/helper/const.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/items/chat_bible.dart';

// ignore: must_be_immutable
class ChatPage extends StatelessWidget {
  ChatPage({super.key});

  final controllerListView = ScrollController();

  CollectionReference messages =
      FirebaseFirestore.instance.collection(collectionMessage);
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var email = ModalRoute.of(context)!
        .settings
        .arguments; // Replace with your email address

    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy('createdAt', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<MessageModel> messageList = [];

          for (QueryDocumentSnapshot doc in snapshot.data!.docs) {
            // Convert the QueryDocumentSnapshot data to a Map
            Map<String, dynamic> jsonData = doc.data() as Map<String, dynamic>;

            // Pass the Map to MessageModel.fromJson
            messageList.add(MessageModel.fromJson(jsonData));
          }

          return Scaffold(
            appBar: AppBar(
              backgroundColor: kPrimaryColor,
              automaticallyImplyLeading: false,
              title: const Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.message,
                      size: 40,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Chat',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    controller: controllerListView,
                    itemCount: messageList.length,
                    itemBuilder: (context, index) {
                      return messageList[index].id == email
                          ? ChatBubble(
                              messageModel: messageList[index],
                            )
                          : ChatBubbleByMyFriend(
                              messageModel: messageList[index],
                            );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          decoration: InputDecoration(
                            hintText: 'Type a message',
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: kPrimaryColor),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: kPrimaryColor),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          if (controller.text.isNotEmpty) {
                            _sendMessage(email as String, controller.text);
                          }
                        },
                        child: CircleAvatar(
                          radius: 28,
                          backgroundColor: kPrimaryColor,
                          child: const Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  void _sendMessage(String email, String message) {
    if (message.isNotEmpty) {
      messages.add({
        'message': message,
        'createdAt': DateTime.now(),
        'id': email,
      });
      controller.clear();
      controllerListView.animateTo(
        0,
        duration: const Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      );
    }
  }
}
