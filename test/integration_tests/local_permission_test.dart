import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_care_app/api/location.dart';
import 'package:health_care_app/localization/hospital_finder.dart';
import 'package:location/location.dart';
import 'package:mockito/mockito.dart';

import '../utils/benchmark_helper.dart';

class MockLocation extends Mock implements Location {
  @override
  Future<bool> serviceEnabled() async => true;

  @override
  Future<PermissionStatus> hasPermission() async => PermissionStatus.granted;

  @override
  Future<LocationData> getLocation() async {
    return LocationData.fromMap({
      'latitude': 40.712776,
      'longitude': -74.005974,
    });
  }
}

void main() {
  testWidgets('location_permission', (tester) async {
    initializeLocation(locationInstance: MockLocation());
    await runPerf(() async {
      await tester.pumpWidget(const MaterialApp(home: HospitalFinder()));
      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump(const Duration(seconds: 2));
      expect(find.text('Current location needed!'), findsNothing);

      expect(find.byIcon(Icons.location_pin), findsWidgets);

      await tester.tap(find.byIcon(Icons.location_pin).first);
      await tester.pumpAndSettle();

      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Localization'), findsOneWidget);
    }, name: 'location_permission');
  });
}
