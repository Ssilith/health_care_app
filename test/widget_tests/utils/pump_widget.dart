// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> pumpWithMaterial(
  WidgetTester tester,
  Widget child, {
  bool settle = false,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.from(
        colorScheme: const ColorScheme.light(),
      ).copyWith(useMaterial3: true),
      home: Scaffold(body: Center(child: child)),
    ),
  );

  if (settle) {
    await tester.pumpAndSettle(const Duration(seconds: 1));
  } else {
    await tester.pump();
  }
}
