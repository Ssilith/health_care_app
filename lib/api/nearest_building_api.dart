import 'dart:convert';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

String url = 'https://api.geoapify.com/v2/places?categories=healthcare';
var apiKey = 'c0b58467168f4bc2b991a3b3445693dc';
int limit = 7;
int distance = 10000;
String filterType = 'circle';

Future<List<Building>> findNearestPharmacy(LocationData locationData) async {
  List<Building> pharmacies = [];
  var latitude = locationData.latitude;
  var longitude = locationData.longitude;

  var response = await http.get(
    Uri.parse(
        '$url.pharmacy&filter=$filterType:$longitude,$latitude,$distance&limit=$limit&apiKey=$apiKey'),
  );

  if (response.statusCode == 200) {
    pharmacies = parseBuilding(response.body);
  }

  return pharmacies;
}

Future<List<Building>> findNearestHospital(LocationData locationData) async {
  List<Building> hospitals = [];
  var latitude = locationData.latitude;
  var longitude = locationData.longitude;

  var response = await http.get(
    Uri.parse(
        '$url.hospital&filter=$filterType:$longitude,$latitude,$distance&limit=$limit&apiKey=$apiKey'),
  );

  if (response.statusCode == 200) {
    hospitals = parseBuilding(response.body);
  }

  return hospitals;
}

List<Building> parseBuilding(String responseBody) {
  final parsed = json.decode(responseBody);

  List<Building> building = [];

  for (var feature in parsed['features']) {
    double lat = feature['geometry']['coordinates'][1];
    double lon = feature['geometry']['coordinates'][0];
    String? name = feature['properties']['name'];
    String? address = feature['properties']['address_line2'];
    String? phone = feature['properties']['datasource']['raw']['phone'];
    String? website = feature['properties']['datasource']['raw']['website'];

    building.add(Building(
      location: LatLng(lat, lon),
      name: name,
      address: address,
      phone: phone,
      website: website,
    ));
  }

  return building;
}

class Building {
  final LatLng location;
  final String? name;
  final String? address;
  final String? phone;
  final String? website;

  Building({
    required this.location,
    required this.name,
    required this.address,
    required this.phone,
    required this.website,
  });
}
