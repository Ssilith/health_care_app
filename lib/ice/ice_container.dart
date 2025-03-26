// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:health_care_app/model/ice_info.dart';
import 'package:health_care_app/services/repository.dart';
import 'package:health_care_app/widgets/message.dart';
import 'package:health_care_app/widgets/popup_window.dart';

class IceContainer extends StatelessWidget {
  final Repository repository;
  final IceInfo info;
  final Function(String) onDelete;
  final VoidCallback onEdit;
  const IceContainer({
    super.key,
    required this.repository,
    required this.info,
    required this.onDelete,
    required this.onEdit,
  });

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
              onPressed: (_) => onEdit(),
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
                            title: "Delete info",
                            message: "Do you really want to delete this info?",
                            onPressed: () async {
                              try {
                                await repository.deleteIceInfo(info.id ?? "");
                                onDelete(info.id ?? "");
                                Navigator.of(context).pop();
                              } catch (e) {
                                displayErrorMotionToast(
                                  'Failed to delete info.',
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
                info.fullName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 5),
              buildInfoRow("Birth Date", info.birthDate, Icons.cake, context),
              buildInfoRow(
                "Gender",
                info.gender,
                Icons.person_outline,
                context,
              ),
              buildInfoRow(
                "Blood Type",
                info.bloodType,
                Icons.bloodtype,
                context,
              ),
              buildInfoRow(
                "Allergies",
                info.allergies,
                Icons.warning_amber,
                context,
              ),
              buildInfoRow(
                "Medical Conditions",
                info.medicalConditions,
                Icons.healing,
                context,
              ),
              buildInfoRow(
                "Medications",
                info.medications,
                Icons.medication,
                context,
              ),
              buildInfoRow(
                "Contact Name",
                info.emergencyContactName,
                Icons.contact_phone,
                context,
              ),
              buildInfoRow(
                "Phone",
                info.emergencyContactNumber,
                Icons.phone,
                context,
              ),
              buildInfoRow("Relation", info.relation, Icons.people, context),
              buildInfoRow(
                "Insurance",
                info.insuranceProvider,
                Icons.shield,
                context,
              ),
              buildInfoRow(
                "Policy #",
                info.insuranceNumber,
                Icons.description,
                context,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfoRow(
    String label,
    String? value,
    IconData icon,
    BuildContext context,
  ) {
    if (value == null || value.trim().isEmpty) return SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black, fontSize: 16),
                children: [
                  TextSpan(
                    text: "$label: ",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
