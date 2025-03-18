// ignore_for_file: use_build_context_synchronously

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:health_care_app/blank_scaffold.dart';
import 'package:health_care_app/model/notification.dart' as notificationmodel;
import 'package:health_care_app/notifications/notification_picker.dart';
import 'package:health_care_app/notifications/notification_service.dart';
import 'package:health_care_app/services/repository.dart';
import 'package:health_care_app/services/repository_impl.dart';
import 'package:health_care_app/widgets/message.dart';
import 'package:health_care_app/widgets/simple_button.dart';
import 'package:health_care_app/widgets/text_input_form.dart';
import 'package:intl/intl.dart';

class NotificationForm extends StatefulWidget {
  final Function(notificationmodel.Notification) onAdd;
  const NotificationForm({super.key, required this.onAdd});

  @override
  State<NotificationForm> createState() => _NotificationFormState();
}

class _NotificationFormState extends State<NotificationForm> {
  final notificationService = NotificationService();
  TextEditingController name = TextEditingController();
  NotificationSchedule schedule = NotificationSchedule.everyDay;

  final Repository repository = RepositoryImpl();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlankScaffold(
        body: SingleChildScrollView(
      child: SizedBox(
        width: size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                height: MediaQuery.of(context).viewInsets.bottom == 0
                    ? size.height * 0.2
                    : 20),
            SvgPicture.asset(
              'assets/undraw_my_notifications_re_ehmk.svg',
              height: size.height * 0.25,
            ),
            const SizedBox(height: 10),
            const Text(
              'New Notification Form',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            TextInputForm(
                width: size.width * 0.9, hint: 'Name', controller: name),
            const SizedBox(height: 5),
            SizedBox(
              width: size.width * 0.9,
              child: NotificationPicker(
                  selectedValue: schedule,
                  returnSchedule: (newSchedule) => setState(() {
                        schedule = newSchedule;
                      })),
            ),
            const SizedBox(height: 10),
            SimpleButton(
                title: 'Submit',
                textColor: Colors.black,
                onPressed: () async {
                  try {
                    int channelId = getRandomIntInRange(0, 200000000);
                    final format = DateFormat('yyyy-MM-dd h:mm a');

                    notificationmodel.Notification notification =
                        notificationmodel.Notification(
                            name: name.text,
                            interval: schedule.toString(),
                            channelId: channelId,
                            scheduledDate: format.parse(formatDate(format)));
                    notificationmodel.Notification addedNotification =
                        await repository.addNotification(notification);
                    widget.onAdd(addedNotification);
                    setCyclicNotifications(schedule, name.text, channelId);
                    Navigator.of(context).pop();
                  } catch (e) {
                    displayErrorMotionToast(
                        'Failed to schedule appointment.', context);
                  }
                }),
          ],
        ),
      ),
    ));
  }

  setCyclicNotifications(
      NotificationSchedule schedule, String name, int id) async {
    await notificationService.scheduleNotification(schedule, name, id);
  }
}

int getRandomIntInRange(int min, int max) {
  final random = Random();
  return min + random.nextInt(max - min);
}

String formatDate(DateFormat format) {
  DateTime now = DateTime.now();
  String formattedDate = format.format(now);
  return formattedDate;
}
