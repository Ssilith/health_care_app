import 'package:location/location.dart';

Future initializeLocation() async {
  final Location location = Location();
  late bool serviceEnabled;
  late PermissionStatus permissionGranted;
  LocationData? locationData;

  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      return;
    }
  }

  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return;
    }
  }
  locationData = await location.getLocation();

  return locationData;
}
