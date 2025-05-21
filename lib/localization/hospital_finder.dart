import 'package:flutter/material.dart';
import 'package:health_care_app/api/location.dart';
import 'package:health_care_app/localization/building_finder.dart';
import 'package:health_care_app/model/building.dart';
import 'package:health_care_app/services/geo_service.dart';
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

  final GeoService geoService = GeoService();

  @override
  void initState() {
    super.initState();
    // loadHospitals();
  }

  // loadHospitals() async {
  //   var locationData = await initializeLocation();
  //   if (locationData != null) {
  //     userLocation = LatLng(locationData.latitude, locationData.longitude);
  //     var hospitalsList = await geoService.findNearestHospital(locationData);
  //     setState(() {
  //       hospitals = hospitalsList;
  //       isLoading = false;
  //     });
  //   } else {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return BuildingFinder(
      isLoading: isLoading,
      userLocation: userLocation,
      building: hospitals,
    );
  }
}
