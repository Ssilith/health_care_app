import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:health_care_app/notifications/notification_service.dart';
import 'package:health_care_app/notifications/notifications_global.dart';

class NotificationPicker extends StatefulWidget {
  final NotificationSchedule? selectedValue;
  final Function(NotificationSchedule) returnSchedule;
  const NotificationPicker(
      {super.key, required this.selectedValue, required this.returnSchedule});

  @override
  State<NotificationPicker> createState() => _NotificationPickerState();
}

class _NotificationPickerState extends State<NotificationPicker> {
  NotificationSchedule? selected;

  @override
  void initState() {
    super.initState();
    selected = widget.selectedValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
                width: 2, color: Theme.of(context).colorScheme.primary),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2(
              isExpanded: true,
              value: selected,
              items: NotificationSchedule.values.map((schedule) {
                return DropdownMenuItem(
                    value: schedule,
                    child: Text(
                      translateNotificationSchedule(schedule),
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ));
              }).toList(),
              onChanged: (NotificationSchedule? val) {
                setState(() {
                  selected = val;
                });
                widget.returnSchedule(selected ?? widget.selectedValue!);
              },
              dropdownStyleData: DropdownStyleData(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
