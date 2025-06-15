import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:help_sum/src/core/constants/app_dimensions.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/widgets/custom_search_field.dart';
import 'package:help_sum/src/widgets/custom_search_field.dart';
import 'package:help_sum/src/widgets/custom_text.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/features/core/common/map_tracking/widgets/location_info_card.dart';

class MapTrackingPage extends StatefulWidget {
  const MapTrackingPage({super.key});

  @override
  State<MapTrackingPage> createState() => _MapTrackingPageState();
}

class _MapTrackingPageState extends State<MapTrackingPage> {
  // final TextEditingController _searchController = TextEditingController();
  bool _showLocationCard = false;
  String _selectedLocationName = '';
  String _selectedLocationDistance = '';
  GoogleMapController? _mapController;

  bool _hasApiKey = true;

  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(33.6844, 73.0479), // Example: Islamabad, Pakistan
    zoom: 14.0,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppPalette.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          color: AppPalette.blackColor,
          onPressed: () => Navigator.pop(context),
        ),
        title: CustomText(
          text: AppTexts.mapTracking,
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          color: AppPalette.blackColor,
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          _hasApiKey
              ? GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _initialCameraPosition,
                onMapCreated: (GoogleMapController controller) {
                  _mapController = controller;
                },
                onTap: (latLng) {
                  if (_showLocationCard) {
                    setState(() {
                      _showLocationCard = false;
                    });
                  }
                },
              )
              : Center(
                child: CustomText(
                  text: 'Google Maps API Key is missing or not configured.',
                  color: AppPalette.errorColor,
                  fontSize: 16.sp,
                  textAlign: TextAlign.center,
                ),
              ),
          Positioned(
            top: AppDimensions.paddingAllSides.h,
            left: AppDimensions.paddingAllSides.w,
            right: AppDimensions.paddingAllSides.w,
            child: CustomSearchField(
              controller: TextEditingController(),
              horizontalPadding: 0,
            ),
          ),
          if (_showLocationCard)
            LocationInfoCard(
              locationName: _selectedLocationName,
              locationDistance: _selectedLocationDistance,
              onDirectionsPressed: () {
                // Handle Directions button tap
              },
              onStartPressed: () {
                // Handle Start button tap
              },
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // _searchController.dispose();
    super.dispose();
  }
}
