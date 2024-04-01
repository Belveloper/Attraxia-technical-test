import 'package:attraxiachat/controllers/chat/chat_cubit.dart';
import 'package:attraxiachat/controllers/chat/chat_state.dart';
import 'package:attraxiachat/models/message.dart';
import 'package:attraxiachat/utils/helpers.dart';
import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:chat_bubbles/bubbles/bubble_special_two.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatView extends StatelessWidget {
  ChatView({
    super.key,
    required this.senderID,
    this.chatID,
  });

  String senderID;
  String? chatID;

  TextEditingController messageController = TextEditingController();

  TextDirection? textDirection;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        FocusScope.of(context).unfocus();
      },
      child: BlocConsumer<ChatCubit, ChatState>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = ChatCubit.getCubit(context);
          return Scaffold(
            appBar: AppBar(
              title: const Row(
                children: [
                  CircleAvatar(
                    radius: 20.0,
                    child: Icon(Icons.person),
                  ),
                  SizedBox(width: 15),
                  Text("SecondUser"),
                ],
              ),
            ),
            body: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
              child: Column(
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: cubit.getMessagesStream(chatId: chatID!),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: Text(
                            "chat with ${senderID != "first" ? "first user" : "second user"}",
                          ),
                        );
                      }
                      List<QueryDocumentSnapshot<Object?>> messages =
                          snapshot.data!.docs.toList();
                      return Expanded(
                        child: messages.isEmpty
                            ? Center(
                                child: Text(
                                  "chat with ${senderID != "first" ? "first user" : "second user"}",
                                ),
                              )
                            : ListView.separated(
                                reverse: true,
                                itemCount: messages.length,
                                separatorBuilder: (cx, _) =>
                                    const SizedBox(height: 15.0),
                                itemBuilder: (cx, index) {
                                  Message message = Message.fromJson(
                                    json: messages[index].data()
                                        as Map<String, dynamic>,
                                  );

                                  if (message.senderID != senderID) {
                                    /// set isRead to true if the widget has built

                                    cubit.setMessageAsRead(
                                      chatId: chatID!,
                                      messageId: messages[index].id,
                                    );
                                    return receiverMessageBubble(
                                        message.content,
                                        message.isRead ?? false);
                                  }

                                  return ownMessageBubble(
                                      message.content, message.isRead ?? false);
                                },
                              ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  StatefulBuilder(
                    builder: (context, set) {
                      return Card(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            //border: Border.all(),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextFormField(
                            controller: messageController,
                            textDirection: textDirection,

                            onChanged: (value) {
                              final oldTextDirection = textDirection;
                              if (value.isEmpty) {
                                textDirection = TextDirection.ltr;
                                if (oldTextDirection != TextDirection.ltr) {}
                                return;
                              }
                              textDirection = detectTextDirection(value[0]);
                              if (oldTextDirection != textDirection) {
                                set(() {});
                              }
                            },
                            decoration: InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 8,
                              ),
                              border: InputBorder.none,
                              hintText: "Message",
                              suffixIcon: MaterialButton(
                                minWidth: 1.0,
                                child: const Icon(
                                  Icons.send,
                                  size: 35,
                                ),
                                onPressed: () async {
                                  messageController.text =
                                      removeLeadingWhitespace(
                                    messageController.text,
                                  );
                                  if (messageController.text.isNotEmpty) {
                                    final message = Message(
                                      content: messageController.text,
                                      senderID: senderID,
                                      timeStamp: DateTime.now(),
                                      isRead: false,
                                    );
                                    messageController.clear();

                                    cubit.sendChatMessage(
                                      message: message,
                                      chatId: chatID,
                                    );
                                  }

                                  //messageController.clear();
                                },
                              ),
                            ),

                            // style:,
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget ownMessageBubble(String message, bool isRead) => BubbleSpecialOne(
        text: message,
        textStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w400,
          fontSize: 18,
        ),
        color: Colors.black,
        seen: isRead,
      );

  Widget receiverMessageBubble(String message, bool isRead) => BubbleSpecialOne(
        text: message,
        textStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w400,
          fontSize: 18,
        ),
        color: Colors.blueGrey,
        isSender: false,
      );
}
