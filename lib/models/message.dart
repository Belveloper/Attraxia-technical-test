import 'package:intl/intl.dart';

class Message {
  late String senderID, content;
  late DateTime timeStamp;
  bool? isRead;

  Message({
    required this.content,
    required this.timeStamp,
    required this.senderID,
    this.isRead = false,
  });

  Message.fromJson({required Map<String, dynamic> json}) {
    content = json['content'] ?? "";
    senderID = json['senderID'].toString();
    timeStamp = DateTime.parse(json['timeStamp'].toString());
    isRead = json['isRead'];
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'senderID': senderID,
      'timeStamp': DateFormat('yyyy-MM-dd HH:mm:ss').format(timeStamp),
      'isRead': isRead,
    };
  }
}
