import 'package:flutter/material.dart';
import 'package:health_care_app/widgets/simple_button.dart';

class PopupWindow extends StatelessWidget {
  final String title;
  final String message;
  final Function() onPressed;
  const PopupWindow({
    super.key,
    required this.title,
    required this.message,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 0,
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w500,
            height: 0.5,
            color: Colors.black),
      ),
      backgroundColor: const Color.fromARGB(249, 243, 246, 254),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SimpleButton(
                  onPressed: () => Navigator.of(context).pop(),
                  title: "Cancel",
                  textColor: const Color.fromARGB(249, 243, 246, 254),
                  width: 120),
              const SizedBox(
                width: 5,
              ),
              SimpleButton(
                  textColor: const Color.fromARGB(249, 243, 246, 254),
                  onPressed: onPressed,
                  title: "Confirm",
                  width: 120),
            ],
          ),
        ],
      ),
    );
  }
}
