import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    name: 'TEST',
    options: const FirebaseOptions(
      apiKey: 'apiKey',
      appId: '1:123:android:123',
      messagingSenderId: '123',
      projectId: 'demo-project',
    ),
  );

  await testMain();
}
