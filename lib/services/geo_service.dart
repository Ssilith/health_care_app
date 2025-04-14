import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:health_care_app/model/building.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

String url = 'https://api.geoapify.com/v2/places?categories=healthcare';
int limit = 7;
int distance = 10000;
String filterType = 'circle';

class GeoService {
  final http.Client client;
  GeoService({http.Client? client}) : client = client ?? http.Client();

  Future<String> getApiKey() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/secrets.json',
      );
      final configData = await json.decode(response);
      return configData['geo_key'];
    } catch (e) {
      return "";
    }
  }

  Future<List<Building>> findNearestPharmacy(LocationData locationData) async {
    String apiKey = await getApiKey();
    final latitude = locationData.latitude;
    final longitude = locationData.longitude;

    var response = await client.get(
      Uri.parse(
        '$url.pharmacy&filter=$filterType:$longitude,$latitude,$distance&limit=$limit&apiKey=$apiKey',
      ),
    );

    if (response.statusCode == 200) {
      return parseBuilding(response.body);
    } else {
      return [];
    }
  }

  Future<List<Building>> findNearestHospital(LocationData locationData) async {
    String apiKey = await getApiKey();
    final latitude = locationData.latitude;
    final longitude = locationData.longitude;

    var response = await client.get(
      Uri.parse(
        '$url.hospital&filter=$filterType:$longitude,$latitude,$distance&limit=$limit&apiKey=$apiKey',
      ),
    );

    if (response.statusCode == 200) {
      return parseBuilding(response.body);
    } else {
      return [];
    }
  }
}

List<Building> parseBuilding(String responseBody) {
  final parsed = json.decode(responseBody);
  List<Building> buildings = [];

  for (var feature in parsed['features']) {
    double lat = feature['geometry']['coordinates'][1];
    double lon = feature['geometry']['coordinates'][0];
    String? name = feature['properties']['name'];
    String? address = feature['properties']['address_line2'];
    String? phone = feature['properties']['datasource']['raw']['phone'];
    String? website = feature['properties']['datasource']['raw']['website'];

    buildings.add(
      Building(
        location: LatLng(lat, lon),
        name: name,
        address: address,
        phone: phone,
        website: website,
      ),
    );
  }
  return buildings;
}
