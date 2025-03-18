import 'package:flutter/material.dart';
import 'package:health_care_app/api/nearest_building_api.dart';
import 'package:health_care_app/localization/navigate_to_container.dart';

class BuildingInfo extends StatelessWidget {
  final Building building;
  const BuildingInfo({super.key, required this.building});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NavigateToContainer(
            icon: Icons.person,
            title: 'Name',
            mess: building.name ?? 'Unknown',
            isOnTap: false,
          ),
          NavigateToContainer(
            icon: Icons.call,
            title: 'Phone number',
            mess: building.phone ?? 'No phone number provided',
            url: 'tel:${building.phone?.replaceAll(' ', '')}',
            isOnTap: building.phone != null,
          ),
          NavigateToContainer(
            icon: Icons.language,
            title: 'Website',
            mess: building.website ?? 'No website provided',
            url: building.website,
            isOnTap: building.website != null,
          ),
          NavigateToContainer(
              icon: Icons.location_on,
              title: 'Localization',
              mess: building.address ?? 'No address provided',
              url:
                  'https://www.google.com/maps/dir/?api=1&destination=${building.location.latitude},${building.location.longitude}&travelmode=driving'),
        ],
      ),
    );
  }
}
