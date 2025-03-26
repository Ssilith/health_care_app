import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:health_care_app/api/nearest_building_api.dart';
import 'package:health_care_app/blank_scaffold.dart';
import 'package:health_care_app/localization/building_details.dart';
import 'package:health_care_app/widgets/loading.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class BuildingFinder extends StatefulWidget {
  final List<Building> building;
  final LatLng? userLocation;
  final bool isLoading;
  const BuildingFinder({
    super.key,
    required this.building,
    this.userLocation,
    required this.isLoading,
  });

  @override
  State<BuildingFinder> createState() => _BuildingFinderState();
}

class _BuildingFinderState extends State<BuildingFinder> {
  bool isLoading = true;

  @override
  void initState() {
    isLoading = widget.isLoading;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant BuildingFinder oldWidget) {
    if (widget.isLoading != oldWidget.isLoading) {
      setState(() {
        isLoading = widget.isLoading;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlankScaffold(
      body:
          isLoading
              ? const Loading()
              : widget.userLocation == null ||
                  widget.building.isEmpty ||
                  widget.building == []
              ? SizedBox(
                width: size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/photos/location.svg',
                      height: size.height * 0.25,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Current location needed!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )
              : FlutterMap(
                options: MapOptions(initialCenter: widget.userLocation!),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: widget.userLocation!,
                        width: 80,
                        height: 80,
                        child: Icon(
                          MdiIcons.circleSlice8,
                          size: 20,
                          color: Colors.blue,
                        ),
                      ),
                      ...widget.building.map(
                        (building) => Marker(
                          width: 80.0,
                          height: 80.0,
                          point: building.location,
                          child: IconButton(
                            onPressed:
                                () => showModalBottomSheet(
                                  context: context,
                                  builder:
                                      (BuildContext context) =>
                                          BuildingInfo(building: building),
                                ),
                            icon: const Icon(
                              Icons.location_pin,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
    );
  }
}
