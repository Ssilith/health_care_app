// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:health_care_app/global.dart';
import 'package:intl/intl.dart';

selectDateTime(BuildContext context, TextEditingController controller) async {
  DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.fromSwatch(
                primarySwatch:
                    getMaterialColor(Theme.of(context).colorScheme.primary)),
          ),
          child: child!,
        );
      });

  if (pickedDate != null) {
    final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: ThemeData(
              colorScheme: ColorScheme.fromSwatch(
                  primarySwatch:
                      getMaterialColor(Theme.of(context).colorScheme.primary)),
            ),
            child: child!,
          );
        });

    if (pickedTime != null) {
      final DateTime finalDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      String formattedDateTime =
          DateFormat('yyyy-MM-dd h:mm a').format(finalDateTime);
      controller.text = formattedDateTime;
    }
  }
}

selectDate(BuildContext context, TextEditingController controller) async {
  DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
            ),
          ),
          child: child!,
        );
      });

  if (pickedDate != null) {
    final DateTime finalDateTime =
        DateTime(pickedDate.year, pickedDate.month, pickedDate.day);

    String formattedDateTime = DateFormat('yyyy-MM-dd').format(finalDateTime);
    controller.text = formattedDateTime;
  }
}
