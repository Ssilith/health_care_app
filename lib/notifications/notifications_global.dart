import 'package:health_care_app/notifications/notification_service.dart';

translateNotificationSchedule(NotificationSchedule schedule) {
  switch (schedule) {
    case NotificationSchedule.everyDay:
      return 'Every day';
    case NotificationSchedule.everyWeek:
      return 'Every week';
    case NotificationSchedule.everyMinute:
      return 'Every minute';
  }
}
