class Message {
  final bool isUserMessage;
  final String message;
  final DateTime dateTime;

  Message(
      {required this.isUserMessage,
      required this.message,
      required this.dateTime});

  Map<String, dynamic> toMap() {
    return {
      'isUserMessage': isUserMessage,
      'message': message,
      'dateTime': dateTime
    };
  }
}
