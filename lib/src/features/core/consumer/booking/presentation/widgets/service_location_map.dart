import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:help_sum/src/core/constants/app_dimensions.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class LocationMapView extends StatelessWidget {
  final double latitude;
  final double longitude;
  final String? heading;

  const LocationMapView({
    super.key,
    required this.latitude,
    required this.longitude,
    this.heading,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingAllSides,
          ).r,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: heading ?? AppTexts.serviceLocation,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
          10.verticalSpace,
          Container(
            height: 200.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                AppDimensions.appBorderRadius.r,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                AppDimensions.appBorderRadius.r,
              ),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(latitude, longitude),
                  zoom: 14.0,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId('serviceLocation'),
                    position: LatLng(latitude, longitude),
                    infoWindow: const InfoWindow(title: 'Service Location'),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueAzure,
                    ),
                  ),
                },
                zoomControlsEnabled: false,
                mapType: MapType.normal,
                myLocationEnabled: false,
                myLocationButtonEnabled: false,
                compassEnabled: true,
                buildingsEnabled: true,
                indoorViewEnabled: false,
                trafficEnabled: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
