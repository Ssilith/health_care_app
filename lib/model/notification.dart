import 'package:cloud_firestore/cloud_firestore.dart';

class Notification {
  final String? id;
  final String? userId;
  final String name;
  final String interval;
  final int channelId;
  final DateTime scheduledDate;

  Notification({
    this.id,
    this.userId,
    required this.name,
    required this.interval,
    required this.channelId,
    required this.scheduledDate,
  });

  factory Notification.fromSnaphot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Notification(
      id: snapshot.id,
      userId: data['userId'] as String?,
      name: data['name'] as String,
      interval: data['interval'] as String,
      channelId: data['channelId'] as int,
      scheduledDate: (data['scheduledDate'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toDTOMap(String userId) {
    return {
      'userId': userId,
      'name': name,
      'interval': interval,
      'channelId': channelId,
      'scheduledDate': Timestamp.fromDate(scheduledDate),
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'interval': interval,
      'channelId': channelId,
      'scheduledDate': scheduledDate.toIso8601String()
    };
  }
}
