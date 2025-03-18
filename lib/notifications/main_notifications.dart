// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:health_care_app/blank_scaffold.dart';
import 'package:health_care_app/notifications/notification_container.dart';
import 'package:health_care_app/notifications/notification_form.dart';
import 'package:health_care_app/notifications/notification_service.dart';
import 'package:health_care_app/notifications/notifications_global.dart';
import 'package:health_care_app/services/repository.dart';
import 'package:health_care_app/services/repository_impl.dart';
import 'package:health_care_app/widgets/message.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:health_care_app/model/notification.dart' as notificationmodel;

class MainNotifications extends StatefulWidget {
  const MainNotifications({super.key});

  @override
  State<MainNotifications> createState() => _MainNotificationsState();
}

class _MainNotificationsState extends State<MainNotifications> {
  final Repository repository = RepositoryImpl();
  final notificationService = NotificationService();
  List<notificationmodel.Notification> notifications = [];
  Map groupedNotification = {};
  Future? getNotifications;


  @override
  void initState() {
    if (Platform.isAndroid){
    requestPermissions();
    }
    getNotifications = repository.getNotifications();
    super.initState();
  }

  requestPermissions() async {
    var notificaionStatus = await Permission.notification.request();
    if (!notificaionStatus.isGranted) {
      displayErrorMotionToast('Required consents were not accepted.', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlankScaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => NotificationForm(
              onAdd: (newNotification) {
                setState(() {
                  notifications.add(newNotification);
                });
              },
            ),
          )),
          shape: const CircleBorder(),
          child: const Icon(Icons.add),
        ),
        body: FutureBuilder(
            future: getNotifications,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(
                    child: Text('An error occured. Please try again later.'));
              } else if (snapshot.data!.isEmpty) {
                return const Center(child: Text('No transaction found.'));
              } else {
                notifications = snapshot.data;
                groupedNotification =
                    groupNotificationsBySchedule(notifications);

                return SizedBox(
                  width: size.width,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 70),
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: NotificationSchedule.values.length,
                          itemBuilder: (context, index) {
                            var notificationsForSchedule = groupedNotification[
                                NotificationSchedule.values[index].toString()];

                            if (notificationsForSchedule != null) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Text(
                                      translateNotificationSchedule(
                                          NotificationSchedule.values[index]),
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black),
                                    ),
                                  ),
                                  ...notificationsForSchedule
                                      .map((notification) => Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: NotificationContainer(
                                              notificationMap: notification,
                                              onDelete: (notificationId) {
                                                setState(() {
                                                  notifications.removeWhere(
                                                      (element) =>
                                                          element.id ==
                                                          notificationId);
                                                });
                                              },
                                            ),
                                          ))
                                      .toList(),
                                ],
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        )
                      ],
                    ),
                  ),
                );
              }
            }));
  }

  Map<String, List<notificationmodel.Notification>>
      groupNotificationsBySchedule(
          List<notificationmodel.Notification> notifications) {
    Map<String, List<notificationmodel.Notification>> groupedBySchedule = {};

    for (notificationmodel.Notification notification in notifications) {
      String schedule = notification.interval;
      if (!groupedBySchedule.containsKey(schedule)) {
        groupedBySchedule[schedule] = [];
      }
      groupedBySchedule[schedule]!.add(notification);
    }

    return groupedBySchedule;
  }
}
