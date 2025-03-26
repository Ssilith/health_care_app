// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:health_care_app/appointments/appointment_container.dart';
import 'package:health_care_app/model/notebook.dart';
import 'package:health_care_app/services/repository.dart';
import 'package:health_care_app/widgets/message.dart';
import 'package:health_care_app/widgets/popup_window.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class NotebookContainer extends StatefulWidget {
  final Repository repository;
  final Notebook note;
  final Function(String) onDelete;
  final VoidCallback onEdit;
  const NotebookContainer({
    super.key,
    required this.repository,
    required this.note,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  State<NotebookContainer> createState() => _NotebookContainerState();
}

class _NotebookContainerState extends State<NotebookContainer> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => setState(() => isExpanded = !isExpanded),
      child: Slidable(
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
                              title: "Delete note",
                              message:
                                  "Do you really want to delete this note?",
                              onPressed: () async {
                                try {
                                  await widget.repository.deleteNote(
                                    widget.note.id ?? "",
                                  );
                                  widget.onDelete(widget.note.id ?? "");
                                  Navigator.of(context).pop();
                                } catch (e) {
                                  displayErrorMotionToast(
                                    'Failed to delete note.',
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
                  widget.note.noteTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                ContainerRow(
                  title: DateFormat(
                    'dd MMMM yyyy h:mm a',
                  ).format(DateTime.parse(widget.note.creationDate)),
                  iconData: MdiIcons.clock,
                  iconSize: 20,
                  textMaxLines: 1,
                ),
                Text(
                  widget.note.noteContent,
                  maxLines: isExpanded ? 100 : 5,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
