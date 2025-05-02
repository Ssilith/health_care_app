import 'package:flutter/foundation.dart';
import 'package:location/location.dart';
import 'package:universal_html/html.dart' as html;

Future initializeLocation({Location? locationInstance}) async {
  final location = locationInstance ?? Location();
  bool serviceEnabled;
  PermissionStatus permissionGranted;
  LocationData locationData;

  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      return;
    }
  }

  permissionGranted =
      kIsWeb
          ? await _checkLocationPermissionOnWeb()
          : await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return;
    }
  }

  locationData = await location.getLocation();
  return locationData;
}

Future<PermissionStatus> _checkLocationPermissionOnWeb() async {
  html.PermissionStatus? status = await html.window.navigator.permissions
      ?.query({'name': 'geolocation'});
  switch (status?.state) {
    case 'granted':
      return PermissionStatus.granted;
    case 'prompt':
      return PermissionStatus.denied;
    case 'denied':
    default:
      return PermissionStatus.deniedForever;
  }
}
