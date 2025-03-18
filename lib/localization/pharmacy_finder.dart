import 'package:flutter/material.dart';
import 'package:health_care_app/api/location.dart';
import 'package:health_care_app/api/nearest_building_api.dart';
import 'package:health_care_app/localization/building_finder.dart';
import 'package:latlong2/latlong.dart';

class PharmacyFinder extends StatefulWidget {
  const PharmacyFinder({super.key});

  @override
  State<PharmacyFinder> createState() => _PharmacyFinderState();
}

class _PharmacyFinderState extends State<PharmacyFinder> {
  List<Building> pharmacies = [];
  LatLng? userLocation;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPharmacies();
  }

  loadPharmacies() async {
    var locationData = await initializeLocation();
    if (locationData != null) {
      userLocation = LatLng(locationData.latitude, locationData.longitude);
      var pharmaciesList = await findNearestPharmacy(locationData);
      setState(() {
        pharmacies = pharmaciesList;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BuildingFinder(
      isLoading: isLoading,
      userLocation: userLocation,
      building: pharmacies,
    );
  }
}
