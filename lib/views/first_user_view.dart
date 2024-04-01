import 'package:attraxiachat/components/conversation_tile.dart';
import 'package:attraxiachat/controllers/chat/chat_cubit.dart';
import 'package:attraxiachat/controllers/chat/chat_state.dart';
import 'package:attraxiachat/models/message.dart';
import 'package:attraxiachat/views/chats_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FirstUserView extends StatelessWidget {
  const FirstUserView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats of first User"),
      ),
      body: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          final cubit = ChatCubit.getCubit(context);
          List<Message> noneReadMessages = [];
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: StreamBuilder<QuerySnapshot<Map>>(
              stream: cubit.getStreamChats(),
              builder: (context, snapshot) {
                final chats = snapshot.data?.docs.toList();
                return !snapshot.hasData || chats!.isEmpty
                    ? const Center(
                        child: Text(
                          "Nothing yet !",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : ListView.separated(
                        itemCount: chats.length,
                        separatorBuilder: (context, _) =>
                            const SizedBox(height: 10.0),
                        itemBuilder: (context, index) {
                          final Message lastMessage = Message.fromJson(
                            json: chats[index].data() as Map<String, dynamic>,
                          );
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ChatView(
                                    senderID: "first",
                                    chatID: chats[index].data()['id'],
                                  ),
                                ),
                              );
                            },
                            child: StreamBuilder<QuerySnapshot<Map>>(
                              stream: cubit.getMessagesStream(
                                chatId: chats[index].id,
                              ),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                noneReadMessages = cubit.getNoneReadMessages(
                                  docs: snapshot.data!.docs,
                                );
                                return ConversationTileWidget(
                                  chatId: 'chat #${index + 1}',
                                  lastMessage: lastMessage,
                                  noReadMessages: noneReadMessages,
                                );
                              },
                            ),
                          );
                        },
                      );
              },
            ),
          );
        },
      ),
    );
  }
}
