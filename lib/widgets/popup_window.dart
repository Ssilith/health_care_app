import 'package:flutter/material.dart';
import 'package:health_care_app/auth/login_button.dart';

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
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 120,
                child: LoginButton(
                  onPressed: () => Navigator.of(context).pop(),
                  isLoading: false,
                  title: "Cancel",
                ),
              ),
              const SizedBox(width: 5),
              SizedBox(
                width: 120,
                child: LoginButton(
                  onPressed: onPressed,
                  isLoading: false,
                  title: "Confirm",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
