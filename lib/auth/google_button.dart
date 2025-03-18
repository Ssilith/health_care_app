import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class GoogleButton extends StatelessWidget {
  final double width;
  final String title;
  final VoidCallback onPressed;
  const GoogleButton({
    super.key,
    required this.width,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 50,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(
              color: Theme.of(context).colorScheme.primary, width: 2)),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Icon(
                MdiIcons.google,
                color: Colors.black,
                size: 23,
              ),
              const SizedBox(width: 5),
              Text(title,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600)),
            ],
          )),
    );
  }
}
