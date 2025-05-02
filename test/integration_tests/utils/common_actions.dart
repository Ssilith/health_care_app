import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> login(WidgetTester tester) async {
  await tester.pumpAndSettle(Duration(seconds: 2));

  // Find all TextFields and use the first two for email and password
  final textFields = find.byType(TextField);
  if (textFields.evaluate().length >= 2) {
    await tester.enterText(textFields.at(0), 'a@a.com');
    await tester.pump();
    await tester.enterText(textFields.at(1), '123456');
    await tester.pump();

    // Find buttons and press the one with LOGIN text
    final buttons = find.byType(TextButton);
    if (buttons.evaluate().isNotEmpty) {
      await tester.tap(buttons.first);
      await tester.pumpAndSettle();
    }
  }
}

Future<void> logout(WidgetTester tester) async {
  await tester.pumpAndSettle();

  final logoutIconButton = find.byIcon(Icons.logout_outlined);
  if (logoutIconButton.evaluate().isNotEmpty) {
    await tester.tap(logoutIconButton);
  } else {
    final iconButtons = find.byType(IconButton);
    if (iconButtons.evaluate().isNotEmpty) {
      await tester.tap(iconButtons.first);
    }
  }

  await tester.pumpAndSettle();
}

Future<void> allowLocationPermission(WidgetTester tester) async {
  final allowBtn = find.textContaining('Allow').first;
  if (allowBtn.evaluate().isNotEmpty) {
    await tester.tap(allowBtn);
    await tester.pumpAndSettle();
  }
}

Future<void> addAppointment(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.add));
  await tester.pumpAndSettle();

  await tester.tap(find.byIcon(Icons.calendar_today).last);
  await tester.pumpAndSettle();

  await tester.enterText(
    find.widgetWithText(TextField, 'Doctor Type'),
    'Cardiologist',
  );
  await tester.enterText(
    find.widgetWithText(TextField, 'Doctor Name'),
    'Dr. Heart',
  );
  await tester.enterText(
    find.widgetWithText(TextField, 'Location'),
    'Clinic C',
  );

  await tester.tap(find.text('SUBMIT'));
  await tester.pumpAndSettle();
}

Future<void> editAppointment(WidgetTester tester) async {
  await tester.drag(find.byType(ListView).first, const Offset(300, 0));
  await tester.tap(find.text('Edit'));
  await tester.pumpAndSettle();

  await tester.enterText(
    find.widgetWithText(TextField, 'Doctor Name'),
    'Dr. Heart-Updated',
  );
  await tester.tap(find.text('SUBMIT'));
  await tester.pumpAndSettle();
}

Future<void> deleteAppointment(WidgetTester tester) async {
  await tester.drag(find.byType(ListView).first, const Offset(300, 0));
  await tester.tap(find.text('Delete'));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('popupConfirmBtn')));
  await tester.pumpAndSettle();
}

Future<void> createNote(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.add));
  await tester.pumpAndSettle();

  await tester.enterText(find.widgetWithText(TextField, 'Title'), 'Test note');
  await tester.enterText(
    find.widgetWithText(TextField, 'Content'),
    'Lorem ipsum',
  );

  await tester.tap(find.text('SUBMIT'));
  await tester.pumpAndSettle();
}

Future<void> deleteNote(WidgetTester tester) async {
  await tester.drag(find.byType(ListView).first, const Offset(300, 0));
  await tester.tap(find.text('Delete'));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('popupConfirmBtn')));
  await tester.pumpAndSettle();
}

Future<void> addIceInfo(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.add));
  await tester.pumpAndSettle();

  await tester.enterText(
    find.widgetWithText(TextField, 'Full Name'),
    'John Doe',
  );
  await tester.enterText(
    find.widgetWithText(TextField, 'Birth Date'),
    '1990-01-01',
  );
  await tester.enterText(find.widgetWithText(TextField, 'Gender'), 'Male');

  await tester.tap(find.text('SUBMIT'));
  await tester.pumpAndSettle();
}

Future<void> deleteIceInfo(WidgetTester tester) async {
  await tester.drag(find.byType(ListView).first, const Offset(300, 0));
  await tester.tap(find.text('Delete'));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('popupConfirmBtn')));
  await tester.pumpAndSettle();
}

Future<void> sendChatMessage(WidgetTester tester) async {
  await tester.enterText(find.byType(TextField).last, 'Hello bot');
  await tester.tap(find.byIcon(Icons.arrow_forward));
  await tester.pumpAndSettle(const Duration(seconds: 1));
}
