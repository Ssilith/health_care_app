import 'dart:io';

int getRssKb() => ProcessInfo.currentRss ~/ 1024;
