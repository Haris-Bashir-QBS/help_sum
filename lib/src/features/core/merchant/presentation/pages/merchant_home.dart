import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/features/auth/data/models/request/update_profile_request_model.dart';
import 'package:help_sum/src/features/auth/presentation/controller/notifiers/auth_notifier.dart';
import 'package:help_sum/src/widgets/custom_text.dart';
import 'package:help_sum/src/widgets/custom_text_formfield.dart';

class MerchantHome extends ConsumerStatefulWidget {
  const MerchantHome({super.key});

  @override
  ConsumerState<MerchantHome> createState() => _MerchantHomeState();
}

class _MerchantHomeState extends ConsumerState<MerchantHome> {
  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(33.6844, 73.0479),
    zoom: 14.0,
  );

  bool switchValue = false;
  GoogleMapController? _mapController;
  Marker? _currentLocationMarker;
  LatLng? _currentLatLng;

  @override
  void initState() {
    super.initState();
    _updateLatLng();
  }

  Future<void> _updateLatLng() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (await Geolocator.isLocationServiceEnabled()) {
      try {
        final position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
          ),
        );

        final newLatLng = LatLng(position.latitude, position.longitude);

        setState(() {
          _currentLatLng = newLatLng;
          _currentLocationMarker = Marker(
            markerId: const MarkerId("current_location"),
            position: newLatLng,
            infoWindow: const InfoWindow(title: "You are here"),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueBlue,
            ),
          );
        });

        _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(newLatLng, 16),
        );

        // Send updated lat/lng to backend
        ref
            .read(authNotifierProvider.notifier)
            .updateLatLong(
              context,
              UpdateProfileRequest(
                lat: newLatLng.latitude,
                long: newLatLng.longitude,
              ),
              onSuccess: () {
                debugPrint("LatLng updated successfully");
              },
            );
      } catch (e) {
        debugPrint("Error getting location: $e");
      }
    } else {
      debugPrint("Location services are disabled.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (controller) => _mapController = controller,
            markers:
                _currentLocationMarker != null ? {_currentLocationMarker!} : {},
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
        ),

        // Top Search Field
        // Positioned(top: 20, left: 12, right: 12, child: _searchField()),

        // Availability Switch
        Positioned(
          top: 30,
          left: 0,
          child: Container(
            width: 0.42.sw,
            height: 60,
            decoration: BoxDecoration(
              color: AppPalette.primaryColor,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 15),
                CupertinoSwitch(
                  thumbColor: Colors.white,
                  activeColor: Colors.white.withOpacity(0.4),
                  trackColor: Colors.white.withOpacity(0.4),
                  value: switchValue,
                  onChanged: (v) {
                    setState(() {
                      switchValue = v;
                    });
                  },
                ),
                const SizedBox(width: 10),
                CustomText(
                  text: "Available",
                  fontWeight: FontWeight.w500,
                  color: AppPalette.fillColor,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Container _searchField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        children: [ 
          Expanded(
            child: CustomTextFormField(
              hint: 'Search...',
              prefixIcon: Icons.search,
            ),
          ),
          const SizedBox(width: 10),
          Icon(Icons.bookmark, size: 30, color: AppPalette.primaryColor),
        ],
      ),
    );
  }
}



  //  lat: 24.900,
                    // long: 67.1060,