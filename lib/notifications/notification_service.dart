import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

enum NotificationSchedule { everyDay, everyWeek, everyMinute }

class NotificationConstants {
  static const String channelID = '6526d64c2c8db4930827e46a';
  static const String channelName = 'healthCareApp';
  static const String channelDescription = 'healthCareAppNotif';
}

const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
  NotificationConstants.channelID,
  NotificationConstants.channelName,
  channelDescription: NotificationConstants.channelDescription,
  importance: Importance.max,
  priority: Priority.high,
);

class NotificationService {
  static final NotificationService _singleton = NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  factory NotificationService() {
    return _singleton;
  }

  NotificationService._internal() {
    const initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/launcher_icon',
    );
    const initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    if (Platform.isAndroid) {
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(
            const AndroidNotificationChannel(
              NotificationConstants.channelID,
              NotificationConstants.channelName,
              description: NotificationConstants.channelDescription,
              importance: Importance.high,
            ),
          );
    }
    // iOS permissions (already configured in initializationSettingsIOS)
  }

  // schedule notification by interval
  scheduleNotification(
    NotificationSchedule schedule,
    String name,
    int channelId,
  ) async {
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    RepeatInterval interval = scheduleNotificationProperly(schedule);

    await flutterLocalNotificationsPlugin.periodicallyShow(
      channelId,
      'Przypomnenie o lekach!',
      'Pamiętaj o wzięciu leku $name.',
      interval,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  // cancel all notification
  cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  // cancel notificaion by channelId
  cancelOneNotification(int channelId) async {
    await flutterLocalNotificationsPlugin.cancel(channelId);
  }

  // scheduled notifications
  getPendingNotifications() async {
    return await flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }

  // currently displayed notifications
  getActiveNotifications() async {
    return await flutterLocalNotificationsPlugin.getActiveNotifications();
  }

  // show nofication now (usually triggered by sth)
  showNotification({
    required String title,
    required String body,
    int id = 0,
  }) async {
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
    );
  }
}

RepeatInterval scheduleNotificationProperly(NotificationSchedule schedule) {
  switch (schedule) {
    case NotificationSchedule.everyDay:
      return RepeatInterval.daily;
    case NotificationSchedule.everyWeek:
      return RepeatInterval.weekly;
    case NotificationSchedule.everyMinute:
      return RepeatInterval.everyMinute;
  }
}
