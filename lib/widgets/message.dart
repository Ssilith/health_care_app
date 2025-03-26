import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';

void displayDeleteMotionToast(String text, BuildContext context) {
  MotionToast.info(
    title: const Text('Info', style: TextStyle(fontWeight: FontWeight.bold)),
    description: Text(text),
    animationType: AnimationType.slideInFromBottom,
    toastAlignment: Alignment.bottomCenter,
    barrierColor: Colors.black,
    width: 300,
    height: 80,
    dismissable: false,
  ).show(context);
}

void displayErrorMotionToast(String text, BuildContext context) {
  MotionToast.error(
    title: const Text('Error', style: TextStyle(fontWeight: FontWeight.bold)),
    description: Text(text),
    animationType: AnimationType.slideInFromBottom,
    toastAlignment: Alignment.bottomCenter,
    barrierColor: Colors.black,
    width: 300,
    height: 80,
    dismissable: false,
  ).show(context);
}

void displaySuccessMotionToast(String text, BuildContext context) {
  MotionToast.success(
    title: const Text('Success', style: TextStyle(fontWeight: FontWeight.bold)),
    description: Text(text),
    animationType: AnimationType.slideInFromBottom,
    toastAlignment: Alignment.bottomCenter,
    barrierColor: Colors.black,
    width: 300,
    height: 80,
    dismissable: false,
  ).show(context);
}
