import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/notification_model.dart';

class NotificationService {

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final String collection = 'notifications';

  /// ADD NOTIFICATION
  Future<void> addNotification(
      NotificationModel notification,
      ) async {

    try {

      await _firestore
          .collection(collection)
          .doc(notification.notificationId)
          .set(notification.toMap());

    } catch (e) {
      rethrow;
    }
  }

  /// DELETE NOTIFICATION
  Future<void> deleteNotification(
      String notificationId,
      ) async {

    try {

      await _firestore
          .collection(collection)
          .doc(notificationId)
          .delete();

    } catch (e) {
      rethrow;
    }
  }

  /// GET NOTIFICATIONS
  Stream<List<NotificationModel>>
  getNotifications() {

    return _firestore
        .collection(collection)
        .orderBy(
      'createdAt',
      descending: true,
    )
        .snapshots()
        .map((snapshot) {

      return snapshot.docs.map((doc) {

        return NotificationModel.fromMap(
          doc.data(),
        );

      }).toList();
    });
  }
}