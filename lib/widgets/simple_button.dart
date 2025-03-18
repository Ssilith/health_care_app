import 'package:flutter/material.dart';

class SimpleButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final Color? buttonColor;
  final Color textColor;
  final double width;
  const SimpleButton(
      {super.key,
      required this.title,
      required this.onPressed,
      this.buttonColor,
      this.textColor = Colors.white,
      this.width = 130});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 3,
              backgroundColor:
                  buttonColor ?? Theme.of(context).colorScheme.primary,
            ),
            onPressed: onPressed,
            child: Text(title,
                style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600))));
  }
}
