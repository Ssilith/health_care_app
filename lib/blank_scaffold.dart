import 'package:flutter/material.dart';
import 'package:health_care_app/global.dart';

class BlankScaffold extends StatelessWidget {
  final Widget body;
  final bool showLeading;
  final Widget? floatingActionButton;
  const BlankScaffold({
    super.key,
    required this.body,
    this.showLeading = true,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: floatingActionButton,
      body: Stack(
        children: [
          Image.asset('logo.png', height: size.height * 0.2),
          body,
          if (showLeading)
            Positioned(
              top: 50,
              left: 15,
              child: IconButton(
                icon: Ink(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: boxShadow,
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    size: 35,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
        ],
      ),
    );
  }
}
