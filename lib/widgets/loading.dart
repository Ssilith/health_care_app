import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final double size;
  const Loading({super.key, this.size = 20});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: size,
        width: size,
        child: CircularProgressIndicator(),
      ),
    );
  }
}
