import 'package:flutter_test/flutter_test.dart';
import '../../utils/benchmark_helper.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:health_care_app/services/geo_service.dart';
import 'package:location/location.dart';

void main() {
  final loc = LocationData.fromMap({'latitude': 0.0, 'longitude': 0.0});

  test('findNearestPharmacy returns [] on 404', () async {
    final client = MockClient((_) async => http.Response('not found', 404));
    final svc = GeoService(client: client);

    await runPerf(() async {
      final r = await svc.findNearestPharmacy(loc);
      expect(r, isEmpty);
    }, name: 'geo_pharmacy_404');
  });
}
