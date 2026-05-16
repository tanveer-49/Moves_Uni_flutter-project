import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../core/services/notification_service.dart';
import '../../models/notification_model.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState
    extends State<NotificationsScreen> {

  final NotificationService _service =
  NotificationService();

  final titleController =
  TextEditingController();

  final messageController =
  TextEditingController();

  bool isLoading = false;

  /// ADD NOTIFICATION
  Future<void> addNotification() async {

    if (titleController.text.trim().isEmpty ||
        messageController.text.trim().isEmpty) {

      showMessage('Please fill all fields');
      return;
    }

    try {

      setState(() {
        isLoading = true;
      });

      final notification =
      NotificationModel(
        notificationId:
        const Uuid().v4(),

        title:
        titleController.text.trim(),

        message:
        messageController.text.trim(),

        createdAt: DateTime.now(),
      );

      await _service.addNotification(
        notification,
      );

      titleController.clear();
      messageController.clear();

      showMessage(
        'Notification Added',
      );

    } catch (e) {

      showMessage(
        e.toString(),
      );

    } finally {

      setState(() {
        isLoading = false;
      });
    }
  }

  /// DELETE NOTIFICATION
  Future<void> deleteNotification(
      String id,
      ) async {

    try {

      await _service.deleteNotification(id);

      showMessage(
        'Notification Deleted',
      );

    } catch (e) {

      showMessage(
        e.toString(),
      );
    }
  }

  /// SNACKBAR
  void showMessage(String message) {

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      const Color(0xffF5F7FA),

      appBar: AppBar(
        title:
        const Text('Notifications'),
        backgroundColor:
        Colors.green,
      ),

      body: Padding(
        padding:
        const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [

            /// LEFT FORM
            Expanded(
              flex: 2,
              child: Container(
                padding:
                const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(
                    20,
                  ),
                ),

                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [

                    const Text(
                      'Add Notification',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    TextField(
                      controller:
                      titleController,

                      decoration:
                      const InputDecoration(
                        labelText: 'Title',
                        border:
                        OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    TextField(
                      controller:
                      messageController,

                      maxLines: 5,

                      decoration:
                      const InputDecoration(
                        labelText:
                        'Message',
                        border:
                        OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    SizedBox(
                      width:
                      double.infinity,
                      height: 50,

                      child:
                      ElevatedButton(

                        onPressed:
                        isLoading
                            ? null
                            : addNotification,

                        style:
                        ElevatedButton.styleFrom(
                          backgroundColor:
                          Colors.green,
                        ),

                        child:
                        isLoading
                            ? const CircularProgressIndicator(
                          color:
                          Colors.white,
                        )
                            : const Text(
                          'Send Notification',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 20),

            /// RIGHT LIST
            Expanded(
              flex: 3,
              child: Container(
                padding:
                const EdgeInsets.all(
                  20,
                ),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(
                    20,
                  ),
                ),

                child:
                StreamBuilder<
                    List<
                        NotificationModel>>(
                  stream: _service
                      .getNotifications(),

                  builder:
                      (context, snapshot) {

                    if (snapshot
                        .connectionState ==
                        ConnectionState
                            .waiting) {

                      return const Center(
                        child:
                        CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {

                      return Center(
                        child: Text(
                          snapshot.error
                              .toString(),
                        ),
                      );
                    }

                    final notifications =
                        snapshot.data ?? [];

                    if (notifications
                        .isEmpty) {

                      return const Center(
                        child: Text(
                          'No notifications found',
                        ),
                      );
                    }

                    return ListView.builder(

                      itemCount:
                      notifications
                          .length,

                      itemBuilder:
                          (context, index) {

                        final notification =
                        notifications[
                        index];

                        return Card(

                          margin:
                          const EdgeInsets.only(
                            bottom: 12,
                          ),

                          child: ListTile(

                            title: Text(
                              notification
                                  .title,

                              style:
                              const TextStyle(
                                fontWeight:
                                FontWeight
                                    .bold,
                              ),
                            ),

                            subtitle:
                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                              children: [

                                const SizedBox(
                                  height: 6,
                                ),

                                Text(
                                  notification
                                      .message,
                                ),

                                const SizedBox(
                                  height: 8,
                                ),

                                Text(
                                  notification
                                      .createdAt
                                      .toString(),

                                  style:
                                  const TextStyle(
                                    fontSize:
                                    12,
                                    color:
                                    Colors
                                        .grey,
                                  ),
                                ),
                              ],
                            ),

                            trailing:
                            IconButton(
                              icon:
                              const Icon(
                                Icons.delete,
                                color:
                                Colors.red,
                              ),

                              onPressed: () {

                                deleteNotification(
                                  notification
                                      .notificationId,
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}