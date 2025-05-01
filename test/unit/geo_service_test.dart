import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_care_app/model/building.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:location/location.dart';
import '../utils/benchmark_helper.dart';
import '../utils/fakes_and_mocks.dart';

void main() {
  group('GeoService Tests', () {
    test('findNearestPharmacy returns a list of Buildings', () async {
      final fakeResponse = {
        "features": [
          {
            "geometry": {
              "coordinates": [100.0, 50.0],
            },
            "properties": {
              "name": "Pharmacy One",
              "address_line2": "123 Pharmacy St",
              "datasource": {
                "raw": {"phone": "111-222", "website": "http://pharmacy.one"},
              },
            },
          },
        ],
      };

      final client = MockClient((request) async {
        return http.Response(jsonEncode(fakeResponse), 200);
      });

      final geoService = FakeGeoService(client: client);

      final locationData = LocationData.fromMap({
        "latitude": 50.0,
        "longitude": 100.0,
      });

      await runPerf(() async {
        await geoService.findNearestPharmacy(locationData);
      }, name: 'geo_findNearestPharmacy');

      final buildings = await geoService.findNearestPharmacy(locationData);

      expect(buildings, isA<List<Building>>());
      expect(buildings.length, equals(1));
      expect(buildings.first.name, equals("Pharmacy One"));
      expect(buildings.first.address, equals("123 Pharmacy St"));
      expect(buildings.first.phone, equals("111-222"));
      expect(buildings.first.website, equals("http://pharmacy.one"));
    });

    test('findNearestHospital returns a list of Buildings', () async {
      final fakeResponse = {
        "features": [
          {
            "geometry": {
              "coordinates": [101.0, 51.0],
            },
            "properties": {
              "name": "Hospital One",
              "address_line2": "456 Hospital Rd",
              "datasource": {
                "raw": {"phone": "333-444", "website": "http://hospital.one"},
              },
            },
          },
        ],
      };

      final client = MockClient((request) async {
        return http.Response(jsonEncode(fakeResponse), 200);
      });

      final geoService = FakeGeoService(client: client);

      final locationData = LocationData.fromMap({
        "latitude": 51.0,
        "longitude": 101.0,
      });

      await runPerf(() async {
        await geoService.findNearestHospital(locationData);
      }, name: 'geo_findNearestHospital');

      final buildings = await geoService.findNearestHospital(locationData);

      expect(buildings, isA<List<Building>>());
      expect(buildings.length, equals(1));
      expect(buildings.first.name, equals("Hospital One"));
      expect(buildings.first.address, equals("456 Hospital Rd"));
      expect(buildings.first.phone, equals("333-444"));
      expect(buildings.first.website, equals("http://hospital.one"));
    });
  });
}
