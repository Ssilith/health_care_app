import 'package:flutter/material.dart';
import 'package:health_care_app/widgets/text_input_form.dart';

class InputDialog extends StatelessWidget {
  final String title;
  final String hint;
  final IconData? iconData;
  final TextEditingController controller;
  final Widget button;
  const InputDialog({
    super.key,
    required this.controller,
    required this.title,
    required this.hint,
    this.iconData,
    required this.button,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextInputForm(
            width: 400,
            controller: controller,
            hint: hint,
            iconData: iconData,
          ),
          const SizedBox(height: 15),
          button,
        ],
      ),
    );
  }
}
