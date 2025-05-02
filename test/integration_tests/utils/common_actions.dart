import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> login(WidgetTester tester) async {
  await tester.pumpAndSettle(Duration(seconds: 2));

  final textFields = find.byType(TextField);
  if (textFields.evaluate().length >= 2) {
    await tester.enterText(textFields.at(0), 'a@a.com');
    await tester.pump();
    await tester.enterText(textFields.at(1), '123456');
    await tester.pump();

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
  await tester.pumpAndSettle(Duration(seconds: 1));
  final allowTexts = ['Allow', 'ALLOW', 'OK', 'Yes', 'Allow while using'];
  for (var text in allowTexts) {
    final allowBtn = find.textContaining(text, findRichText: true);
    if (allowBtn.evaluate().isNotEmpty) {
      await tester.tap(allowBtn.first);
      await tester.pumpAndSettle();
      return;
    }
  }
}

Future<void> addAppointment(WidgetTester tester) async {
  final addButton = find.byIcon(Icons.add);
  if (addButton.evaluate().isNotEmpty) {
    await tester.tap(addButton.first);
    await tester.pumpAndSettle();

    final calendarIcon = find.byIcon(Icons.calendar_today);
    if (calendarIcon.evaluate().isNotEmpty) {
      await tester.tap(calendarIcon.last);
      await tester.pumpAndSettle();
    }

    await tester.enterText(
      find.widgetWithText(TextField, 'Doctor Type'),
      'Cardiologist',
    );
    await tester.pump(Duration(milliseconds: 200));

    await tester.enterText(
      find.widgetWithText(TextField, 'Doctor Name'),
      'Dr. Heart',
    );
    await tester.pump(Duration(milliseconds: 200));

    await tester.enterText(
      find.widgetWithText(TextField, 'Location'),
      'Clinic C',
    );
    await tester.pump(Duration(milliseconds: 200));

    final submitButton = find.text('SUBMIT');
    if (submitButton.evaluate().isNotEmpty) {
      await tester.tap(submitButton);
      await tester.pumpAndSettle();
    }
  }
}

Future<void> editAppointment(WidgetTester tester) async {
  final listView = find.byType(ListView);
  if (listView.evaluate().isNotEmpty) {
    await tester.drag(listView.first, const Offset(300, 0));
    await tester.pumpAndSettle();

    final editButton = find.text('Edit');
    if (editButton.evaluate().isNotEmpty) {
      await tester.tap(editButton);
      await tester.pumpAndSettle();

      final doctorNameField = find.widgetWithText(TextField, 'Doctor Name');
      if (doctorNameField.evaluate().isNotEmpty) {
        await tester.enterText(doctorNameField, 'Dr. Heart-Updated');
        await tester.pump(Duration(milliseconds: 200));
      }
      final submitButton = find.text('SUBMIT');
      if (submitButton.evaluate().isNotEmpty) {
        await tester.tap(submitButton);
        await tester.pumpAndSettle();
      }
    }
  }
}

Future<void> deleteAppointment(WidgetTester tester) async {
  final listView = find.byType(ListView);
  if (listView.evaluate().isNotEmpty) {
    await tester.drag(listView.first, const Offset(300, 0));
    await tester.pumpAndSettle();

    final deleteButton = find.text('Delete');
    if (deleteButton.evaluate().isNotEmpty) {
      await tester.tap(deleteButton);
      await tester.pumpAndSettle();

      final confirmButton = find.byKey(const Key('popupConfirmBtn'));
      if (confirmButton.evaluate().isNotEmpty) {
        await tester.tap(confirmButton);
        await tester.pumpAndSettle();
      } else {
        final confirmText = find.text('Confirm');
        if (confirmText.evaluate().isNotEmpty) {
          await tester.tap(confirmText);
          await tester.pumpAndSettle();
        }
      }
    }
  }
}

Future<void> createNote(WidgetTester tester) async {
  final addButton = find.byIcon(Icons.add);
  if (addButton.evaluate().isNotEmpty) {
    await tester.tap(addButton.first);
    await tester.pumpAndSettle();

    final speedDialChild = find.byType(SpeedDialChild);
    if (speedDialChild.evaluate().isNotEmpty) {
      await tester.tap(speedDialChild.first);
      await tester.pumpAndSettle();
    }

    final titleField = find.widgetWithText(TextField, 'Title');
    if (titleField.evaluate().isNotEmpty) {
      await tester.enterText(titleField, 'Test note');
      await tester.pump(Duration(milliseconds: 200));
    }

    final contentField = find.widgetWithText(TextField, 'Content');
    if (contentField.evaluate().isNotEmpty) {
      await tester.enterText(contentField, 'Lorem ipsum');
      await tester.pump(Duration(milliseconds: 200));
    }

    final submitButton = find.text('SUBMIT');
    if (submitButton.evaluate().isNotEmpty) {
      await tester.tap(submitButton);
      await tester.pumpAndSettle();
    }
  }
}

Future<void> editNote(WidgetTester tester) async {
  final listView = find.byType(ListView);
  if (listView.evaluate().isNotEmpty) {
    await tester.drag(listView.first, const Offset(300, 0));
    await tester.pumpAndSettle();

    final editButton = find.text('Edit');
    if (editButton.evaluate().isNotEmpty) {
      await tester.tap(editButton);
      await tester.pumpAndSettle();

      final contentField = find.widgetWithText(TextField, 'Content');
      if (contentField.evaluate().isNotEmpty) {
        await tester.enterText(contentField, 'Updated content');
        await tester.pump(Duration(milliseconds: 200));
      }

      final submitButton = find.text('SUBMIT');
      if (submitButton.evaluate().isNotEmpty) {
        await tester.tap(submitButton);
        await tester.pumpAndSettle();
      }
    } else {
      // Try alternative ways to find the edit button
      final editIcons = find.byIcon(Icons.edit);
      if (editIcons.evaluate().isNotEmpty) {
        await tester.tap(editIcons.first);
        await tester.pumpAndSettle();

        final contentField = find.widgetWithText(TextField, 'Content');
        if (contentField.evaluate().isNotEmpty) {
          await tester.enterText(contentField, 'Updated content');
          await tester.pump(Duration(milliseconds: 200));
        }

        final submitButton = find.text('SUBMIT');
        if (submitButton.evaluate().isNotEmpty) {
          await tester.tap(submitButton);
          await tester.pumpAndSettle();
        }
      }
    }
  }
}

Future<void> deleteNote(WidgetTester tester) async {
  final listView = find.byType(ListView);
  if (listView.evaluate().isNotEmpty) {
    await tester.drag(listView.first, const Offset(300, 0));
    await tester.pumpAndSettle();

    final deleteButton = find.text('Delete');
    if (deleteButton.evaluate().isNotEmpty) {
      await tester.tap(deleteButton);
      await tester.pumpAndSettle();

      final confirmButton = find.byKey(const Key('popupConfirmBtn'));
      if (confirmButton.evaluate().isNotEmpty) {
        await tester.tap(confirmButton);
        await tester.pumpAndSettle();
      } else {
        final confirmText = find.text('Confirm');
        if (confirmText.evaluate().isNotEmpty) {
          await tester.tap(confirmText);
          await tester.pumpAndSettle();
        }
      }
    }
  }
}

Future<void> addIceInfo(WidgetTester tester) async {
  final addButton = find.byIcon(Icons.add);
  if (addButton.evaluate().isNotEmpty) {
    await tester.tap(addButton.first);
    await tester.pumpAndSettle();

    final fullNameField = find.widgetWithText(TextField, 'Full Name');
    if (fullNameField.evaluate().isNotEmpty) {
      await tester.enterText(fullNameField, 'John Doe');
      await tester.pump(Duration(milliseconds: 200));
    }
    final birthDateField = find.widgetWithText(TextField, 'Birth Date');
    if (birthDateField.evaluate().isNotEmpty) {
      await tester.enterText(birthDateField, '1990-01-01');
      await tester.pump(Duration(milliseconds: 200));
    }

    final genderField = find.widgetWithText(TextField, 'Gender');
    if (genderField.evaluate().isNotEmpty) {
      await tester.enterText(genderField, 'Male');
      await tester.pump(Duration(milliseconds: 200));
    }

    final submitButton = find.text('SUBMIT');
    if (submitButton.evaluate().isNotEmpty) {
      await tester.tap(submitButton);
      await tester.pumpAndSettle();
    }
  }
}

Future<void> editIceInfo(WidgetTester tester) async {
  final listView = find.byType(ListView);
  if (listView.evaluate().isNotEmpty) {
    await tester.drag(listView.first, const Offset(300, 0));
    await tester.pumpAndSettle();

    final editButton = find.text('Edit');
    if (editButton.evaluate().isNotEmpty) {
      await tester.tap(editButton);
      await tester.pumpAndSettle();

      final bloodTypeField = find.widgetWithText(TextField, 'Blood Type');
      if (bloodTypeField.evaluate().isNotEmpty) {
        await tester.enterText(bloodTypeField, 'A+');
        await tester.pump(Duration(milliseconds: 200));
      }

      final allergiesField = find.widgetWithText(TextField, 'Allergies');
      if (allergiesField.evaluate().isNotEmpty) {
        await tester.enterText(allergiesField, 'Peanuts, Shellfish');
        await tester.pump(Duration(milliseconds: 200));
      }

      final submitButton = find.text('SUBMIT');
      if (submitButton.evaluate().isNotEmpty) {
        await tester.tap(submitButton);
        await tester.pumpAndSettle();
      }
    } else {
      final editIcons = find.byIcon(Icons.edit);
      if (editIcons.evaluate().isNotEmpty) {
        await tester.tap(editIcons.first);
        await tester.pumpAndSettle();

        final bloodTypeField = find.widgetWithText(TextField, 'Blood Type');
        if (bloodTypeField.evaluate().isNotEmpty) {
          await tester.enterText(bloodTypeField, 'A+');
          await tester.pump(Duration(milliseconds: 200));
        }

        final allergiesField = find.widgetWithText(TextField, 'Allergies');
        if (allergiesField.evaluate().isNotEmpty) {
          await tester.enterText(allergiesField, 'Peanuts, Shellfish');
          await tester.pump(Duration(milliseconds: 200));
        }

        final submitButton = find.text('SUBMIT');
        if (submitButton.evaluate().isNotEmpty) {
          await tester.tap(submitButton);
          await tester.pumpAndSettle();
        }
      }
    }
  }
}

Future<void> deleteIceInfo(WidgetTester tester) async {
  final listView = find.byType(ListView);
  if (listView.evaluate().isNotEmpty) {
    await tester.drag(listView.first, const Offset(300, 0));
    await tester.pumpAndSettle();

    final deleteButton = find.text('Delete');
    if (deleteButton.evaluate().isNotEmpty) {
      await tester.tap(deleteButton);
      await tester.pumpAndSettle();

      final confirmButton = find.byKey(const Key('popupConfirmBtn'));
      if (confirmButton.evaluate().isNotEmpty) {
        await tester.tap(confirmButton);
        await tester.pumpAndSettle();
      } else {
        final confirmText = find.text('Confirm');
        if (confirmText.evaluate().isNotEmpty) {
          await tester.tap(confirmText);
          await tester.pumpAndSettle();
        }
      }
    }
  }
}

Future<void> sendChatMessageEnhanced(WidgetTester tester) async {
  await tester.pumpAndSettle();

  final textFields = find.byType(TextField);
  if (textFields.evaluate().isEmpty) {
    return;
  }

  await tester.enterText(textFields.last, 'Hello bot');
  await tester.pump();

  final sendButton = find.byIcon(Icons.arrow_forward);
  if (sendButton.evaluate().isNotEmpty) {
    await tester.tap(sendButton.first);
  } else {
    final iconButtons = find.byType(IconButton);
    if (iconButtons.evaluate().isNotEmpty) {
      await tester.tap(iconButtons.last);
    }
  }

  await tester.pumpAndSettle();
}
