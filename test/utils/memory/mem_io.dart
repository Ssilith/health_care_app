import 'dart:io' as io;

int getCurrentMemory() => io.ProcessInfo.currentRss;
