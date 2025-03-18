// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:health_care_app/model/appointment.dart';
import 'package:health_care_app/services/repository.dart';
import 'package:health_care_app/widgets/message.dart';
import 'package:health_care_app/widgets/popup_window.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AppointnentContainer extends StatelessWidget {
  final Appointment appointmentMap;
  final Repository repository;
  final Function(String) onDelete;
  const AppointnentContainer(
      {super.key,
      required this.appointmentMap,
      required this.repository,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      startActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          IconTheme(
              data: IconTheme.of(context)
                  .copyWith(color: Theme.of(context).focusColor),
              child: SlidableAction(
                  borderRadius: BorderRadius.circular(10),
                  backgroundColor: Colors.white,
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  icon: Icons.delete,
                  label: "Delete",
                  onPressed: (context) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return PopupWindow(
                          title: "Delete appointment",
                          message:
                              "Do you really want to delete this appointment?",
                          onPressed: () async {
                            try {
                              await repository
                                  .deleteAppointment(appointmentMap.id ?? "");
                              onDelete(appointmentMap.id ?? "");
                              Navigator.of(context).pop();
                            } catch (e) {
                              displayErrorMotionToast(
                                  'Failed to delete appointment.', context);
                            }
                          },
                        );
                      },
                    );
                  })),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color.fromARGB(249, 243, 246, 254),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                appointmentMap.doctorType,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
              ContainerRow(
                  title: appointmentMap.doctorName,
                  iconData: Icons.person,
                  textMaxLines: 1),
              ContainerRow(
                  title: DateFormat('h:mm a').format(appointmentMap.date),
                  iconData: MdiIcons.clock,
                  iconSize: 20,
                  textMaxLines: 1),
              ContainerRow(
                  title: appointmentMap.location, iconData: Icons.location_pin),
              appointmentMap.purpose != null && appointmentMap.purpose != ""
                  ? Row(
                      children: [
                        Center(
                          child: Icon(Icons.description,
                              size: 20, color: Theme.of(context).primaryColor),
                        ),
                        const SizedBox(width: 5),
                        Expanded(child: Text(appointmentMap.purpose!)),
                      ],
                    )
                  : const SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }
}

class ContainerRow extends StatelessWidget {
  final String title;
  final IconData iconData;
  final double iconSize;
  final int textMaxLines;
  const ContainerRow(
      {super.key,
      required this.title,
      required this.iconData,
      this.iconSize = 22,
      this.textMaxLines = 2});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Center(
          child: Icon(iconData,
              size: iconSize, color: Theme.of(context).primaryColor),
        ),
        if (textMaxLines != 2) const SizedBox(width: 5),
        Expanded(
          child: Text(
            title,
            maxLines: textMaxLines,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
          ),
        ),
      ],
    );
  }
}
