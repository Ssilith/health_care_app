// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_care_app/appointments/main_appointments.dart';
import 'package:health_care_app/chat/chat_page.dart';
import 'package:health_care_app/localization/hospital_finder.dart';
import 'package:health_care_app/localization/pharmacy_finder.dart';
import 'package:health_care_app/notebook/main_notebook.dart';
import 'package:health_care_app/notifications/main_notifications.dart';

List<Map<String, String>> homePageActions = [
  {'Pill notifications': 'assets/undraw_medical_care_movn.svg'},
  {'Med notebook': 'assets/undraw_undraw_notebook_ask4_ew5s.svg'},
  {'Appointments': 'assets/undraw_doctors_p6aq.svg'},
  {'Chat bot': 'assets/undraw_chat_re_re1u.svg'},
  {'Nearest hospitals': 'assets/undraw_building_re_xfcm.svg'},
  {'Nearest pharmacies': 'assets/undraw_map_re_60yf.svg'},
];

Widget getActionRoute(String actionKey) {
  switch (actionKey) {
    case 'Pill notifications':
      return const MainNotifications();
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

List<BoxShadow> boxShadow = [
  const BoxShadow(
    color: Colors.grey,
    blurRadius: 2.0,
    spreadRadius: 0.0,
    offset: Offset(0.0, 4.0),
  ),
];

copyToClipboard(String text) {
  Clipboard.setData(ClipboardData(text: text));
}

MaterialColor getMaterialColor(Color color) {
  final int red = color.red;
  final int green = color.green;
  final int blue = color.blue;

  final Map<int, Color> shades = {
    50: Color.fromRGBO(red, green, blue, .1),
    100: Color.fromRGBO(red, green, blue, .2),
    200: Color.fromRGBO(red, green, blue, .3),
    300: Color.fromRGBO(red, green, blue, .4),
    400: Color.fromRGBO(red, green, blue, .5),
    500: Color.fromRGBO(red, green, blue, .6),
    600: Color.fromRGBO(red, green, blue, .7),
    700: Color.fromRGBO(red, green, blue, .8),
    800: Color.fromRGBO(red, green, blue, .9),
    900: Color.fromRGBO(red, green, blue, 1),
  };

  return MaterialColor(color.value, shades);
}
