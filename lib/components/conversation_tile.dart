// ignore_for_file: non_constant_identifier_names

import 'package:attraxiachat/models/message.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';

Widget ConversationTileWidget({
  String userID = 'first', //to see if we're with first user or second
  required String chatId,
  required Message lastMessage,
  required List<Message> noReadMessages,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Badge(
      isLabelVisible: noReadMessages.isNotEmpty,
      label: Text("${noReadMessages.length}"),
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(vertical: 5),
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 22,
              backgroundColor: Color.fromARGB(255, 7, 51, 107),
              child: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      chatId,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  "${lastMessage.senderID == userID ? "you : " : ""}${lastMessage.content}",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: noReadMessages.isEmpty ? 13 : 15,
                    fontWeight: noReadMessages.isEmpty
                        ? FontWeight.w300
                        : FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  timeago.format(lastMessage.timeStamp),
                  style: TextStyle(
                    color: Colors.grey.shade300,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
