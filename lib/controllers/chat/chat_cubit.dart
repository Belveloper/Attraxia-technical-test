import 'chat_state.dart';
import '../../models/message.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitialState());

  static ChatCubit getCubit(BuildContext context) => BlocProvider.of(context);

  final firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> getStreamChats() {
    return firestore
        .collection("chats")
        .orderBy('timeStamp', descending: true)
        .snapshots(includeMetadataChanges: true);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessagesStream({
    required String chatId,
  }) {
    return firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timeStamp', descending: true)
        .snapshots(includeMetadataChanges: true);
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getStreamReading({
    required String chatId,
    required String messageId,
  }) {
    return firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .snapshots(includeMetadataChanges: true);
  }

  String createChatId() {
    ///create chatDoc
    final DocumentReference<Map<String, dynamic>> chatDoc =
        firestore.collection('chats').doc();

    ///set chatId to chatDocX fields (this instruction is required when get docs)
    chatDoc.set({
      "id": chatDoc.id,
      "timeStamp": DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
    });

    return chatDoc.id;
  }

  Future<void> sendChatMessage({
    required Message message,
    String? chatId,
  }) async {
    final doc = firestore.collection('chats').doc(chatId);

    ///set last message model
    doc.set({
      'id': doc.id,
      ...message.toJson(),
    });
    doc.collection("messages").add(message.toJson());
  }

  void setMessageAsRead({
    required String chatId,
    required String messageId,
  }) {
    firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .update({'isRead': true});
  }

  List<Message> getNoneReadMessages({
    bool isFirstUser = true,
    required List<QueryDocumentSnapshot<Map>> docs,
  }) {
    String senderID = isFirstUser ? 'first' : 'second';
    return docs
        .where((element) =>
            element.data()['isRead'] == false &&
            element.data()['senderID'] != senderID)
        .map(
          (message) => Message.fromJson(
            json: message.data() as Map<String, dynamic>,
          ),
        )
        .toList();
  }
}
