class NotificationModel {
  final String notificationId;
  final String title;
  final String message;
  final DateTime createdAt;

  NotificationModel({
    required this.notificationId,
    required this.title,
    required this.message,
    required this.createdAt,
  });

  factory NotificationModel.fromMap(
      Map<String, dynamic> map,
      ) {
    return NotificationModel(
      notificationId: map['notificationId'] ?? '',
      title: map['title'] ?? '',
      message: map['message'] ?? '',
      createdAt:
      map['createdAt'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'notificationId': notificationId,
      'title': title,
      'message': message,
      'createdAt': createdAt,
    };
  }
}