import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_care_app/appointments/main_appointments.dart';
import 'package:health_care_app/chat/chat_page.dart';
import 'package:health_care_app/ice/main_ice.dart';
import 'package:health_care_app/localization/hospital_finder.dart';
import 'package:health_care_app/localization/pharmacy_finder.dart';
import 'package:health_care_app/notebook/main_notebook.dart';

List<Map<String, IconData>> homePageActions = [
  {'In case of emergency': Icons.warning_amber_rounded},
  {'Med notebook': Icons.note},
  {'Appointments': Icons.calendar_today},
  {'Chat bot': Icons.chat},
  {'Nearest hospitals': Icons.local_hospital},
  {'Nearest pharmacies': Icons.local_pharmacy},
];

Widget getActionRoute(String actionKey) {
  switch (actionKey) {
    case 'In case of emergency':
      return const MainIce();
    case 'Med notebook':
      return const MainNotebook();
    case 'Appointments':
      return const MainAppointments();
    case 'Chat bot':
      return const ChatPage();
    case 'Nearest hospitals':
      return const HospitalFinder();
    case 'Nearest pharmacies':
      return const PharmacyFinder();
  }
  return const SizedBox.shrink();
}

copyToClipboard(String text) {
  Clipboard.setData(ClipboardData(text: text));
}
