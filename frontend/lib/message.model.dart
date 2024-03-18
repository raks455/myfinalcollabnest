class Message {
  final String senderUserId;
  final String receiverUserId;
  final String message;
  final DateTime timestamp;
  final String messageid;
  Message(
      {required this.senderUserId,
      required this.receiverUserId,
      required this.messageid,
      required this.message,
      required this.timestamp});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      senderUserId: json['sender'],
      receiverUserId: json['receiver'],
      message: json['text'],
      messageid: json['id'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
  Map<String, dynamic> toJson() {
    

    return {
      'sender': senderUserId,
      'receiver': receiverUserId,
      'text': message,
      'id': messageid,
      'timestamp': timestamp.toIso8601String(),
    };

  }

}
