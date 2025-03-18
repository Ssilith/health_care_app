import 'package:flutter/material.dart';
import 'package:health_care_app/api/location.dart';
import 'package:health_care_app/api/nearest_building_api.dart';
import 'package:health_care_app/localization/building_finder.dart';
import 'package:latlong2/latlong.dart';

class HospitalFinder extends StatefulWidget {
  const HospitalFinder({super.key});

  @override
  State<HospitalFinder> createState() => _HospitalFinderState();
}

class _HospitalFinderState extends State<HospitalFinder> {
  List<Building> hospitals = [];
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
      var hospitalsList = await findNearestHospital(locationData);
      setState(() {
        hospitals = hospitalsList;
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
      building: hospitals,
    );
  }
}
