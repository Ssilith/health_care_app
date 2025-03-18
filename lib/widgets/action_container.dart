import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:health_care_app/global.dart';

class ActionContainer extends StatelessWidget {
  final String title;
  final String assetUrl;
  final VoidCallback onTap;
  const ActionContainer(
      {super.key,
      required this.title,
      required this.assetUrl,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      splashColor: Colors.transparent,
      onTap: onTap,
      child: Container(
          width: size.width * 0.45,
          decoration: BoxDecoration(
              boxShadow: boxShadow,
              color: const Color(0xFFD9D9D9),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              border: Border.all(
                  color: Theme.of(context).colorScheme.primary, width: 2)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SvgPicture.asset(
                  fit: BoxFit.contain,
                  assetUrl,
                  height: 120,
                ),
              ),
            ],
          )),
    );
  }
}
