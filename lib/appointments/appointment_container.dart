import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:health_care_app/model/appointment.dart';
import 'package:health_care_app/services/appointment_service.dart';
import 'package:health_care_app/widgets/message.dart';
import 'package:health_care_app/widgets/popup_window.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AppointmentContainer extends StatefulWidget {
  final Appointment appointment;
  final Function(String) onDelete;
  final VoidCallback onEdit;
  final AppointmentService? appointmentService;
  const AppointmentContainer({
    super.key,
    required this.appointment,
    required this.onDelete,
    required this.onEdit,
    this.appointmentService,
  });

  @override
  State<AppointmentContainer> createState() => _AppointmentContainerState();
}

class _AppointmentContainerState extends State<AppointmentContainer> {
  late AppointmentService appointmentService;

  @override
  void initState() {
    appointmentService = widget.appointmentService ?? AppointmentService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      startActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          IconTheme(
            data: IconTheme.of(
              context,
            ).copyWith(color: Theme.of(context).focusColor),
            child: SlidableAction(
              borderRadius: BorderRadius.circular(10),
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              foregroundColor: Theme.of(context).colorScheme.primary,
              icon: Icons.edit,
              label: "Edit",
              onPressed: (_) => widget.onEdit(),
            ),
          ),
          IconTheme(
            data: IconTheme.of(
              context,
            ).copyWith(color: Theme.of(context).focusColor),
            child: SlidableAction(
              borderRadius: BorderRadius.circular(10),
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              foregroundColor: Theme.of(context).colorScheme.primary,
              icon: Icons.delete,
              label: "Delete",
              onPressed: (context) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      contentPadding: EdgeInsets.zero,
                      content: Builder(
                        builder: (context) {
                          return PopupWindow(
                            title: "Delete appointment",
                            message:
                                "Do you really want to delete this appointment?",
                            onPressed: () async {
                              try {
                                await appointmentService.deleteAppointment(
                                  widget.appointment.id ?? "",
                                );
                                widget.onDelete(widget.appointment.id ?? "");
                                Navigator.of(context).pop();
                              } catch (e) {
                                displayErrorMotionToast(
                                  'Failed to delete appointment.',
                                  context,
                                );
                              }
                            },
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.appointment.doctorType,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              ContainerRow(
                title: widget.appointment.doctorName,
                iconData: Icons.person,
                textMaxLines: 1,
              ),
              ContainerRow(
                title: DateFormat('h:mm a').format(widget.appointment.date),
                iconData: MdiIcons.clock,
                iconSize: 20,
                textMaxLines: 1,
              ),
              ContainerRow(
                title: widget.appointment.location,
                iconData: Icons.location_pin,
              ),
              widget.appointment.purpose != null &&
                      widget.appointment.purpose != ""
                  ? Row(
                    children: [
                      Center(
                        child: Icon(
                          Icons.description,
                          size: 20,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(child: Text(widget.appointment.purpose!)),
                    ],
                  )
                  : const SizedBox.shrink(),
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
  const ContainerRow({
    super.key,
    required this.title,
    required this.iconData,
    this.iconSize = 22,
    this.textMaxLines = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Center(
          child: Icon(
            iconData,
            size: iconSize,
            color: Theme.of(context).primaryColor,
          ),
        ),
        if (textMaxLines != 2) const SizedBox(width: 5),
        Expanded(
          child: Text(
            title,
            maxLines: textMaxLines,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
