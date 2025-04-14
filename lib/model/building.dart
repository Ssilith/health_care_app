import 'package:latlong2/latlong.dart';

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
