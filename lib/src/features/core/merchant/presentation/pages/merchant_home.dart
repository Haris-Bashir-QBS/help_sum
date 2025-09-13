import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart'
    as places_sdk;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_secrets.dart';
import 'package:help_sum/src/features/auth/data/models/request/update_profile_request_model.dart';
import 'package:help_sum/src/features/auth/presentation/controller/notifiers/auth_notifier.dart';
import 'package:help_sum/src/widgets/custom_text.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/widgets/location_typeahead_field.dart';
import 'package:cherry_toast/cherry_toast.dart';

class MerchantMapScreen extends ConsumerStatefulWidget {
  const MerchantMapScreen({super.key});

  @override
  ConsumerState<MerchantMapScreen> createState() => _MerchantMapScreenState();
}

class _MerchantMapScreenState extends ConsumerState<MerchantMapScreen> {
  static final gmaps.CameraPosition _initialCameraPosition =
      const gmaps.CameraPosition(
        target: gmaps.LatLng(33.6844, 73.0479),
        zoom: 14,
      );

  gmaps.GoogleMapController? _mapController;
  LatLng? _currentLatLng;
  gmaps.Marker? _currentMarker;

  bool switchValue = false;
  bool _locationPermissionGranted = false;

  final places_sdk.FlutterGooglePlacesSdk _places =
      places_sdk.FlutterGooglePlacesSdk(AppSecrets.googleApiKey);

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkLocationPermissionAndFetch();
  }

  Future<void> _checkLocationPermissionAndFetch() async {
    geolocator.LocationPermission permission =
        await geolocator.Geolocator.checkPermission();
    if (permission == geolocator.LocationPermission.denied) {
      permission = await geolocator.Geolocator.requestPermission();
    }

    if (await geolocator.Geolocator.isLocationServiceEnabled() &&
        (permission == geolocator.LocationPermission.always ||
            permission == geolocator.LocationPermission.whileInUse)) {
      _locationPermissionGranted = true;
      final position = await geolocator.Geolocator.getCurrentPosition(
        locationSettings: const geolocator.LocationSettings(
          accuracy: geolocator.LocationAccuracy.high,
        ),
      );
      _updateMarkerAndCamera(position.latitude, position.longitude);
    } else {
      _locationPermissionGranted = false;
      CherryToast.info(
        title: const Text("Location Permission Denied"),
        description: const Text(
          "Please enable location services or grant permission.",
        ),
      ).show(context);
    }
  }

  void _updateMarkerAndCamera(double lat, double long) {
    final newLatLng = gmaps.LatLng(lat, long);
    if (mounted) {
      setState(() {
        _currentLatLng = newLatLng;
        _currentMarker = gmaps.Marker(
          markerId: const gmaps.MarkerId("current_location"),
          position: newLatLng,
          draggable: true,
          onDragEnd: (newPos) {
            _currentLatLng = newPos;
            _updateBackendLatLng(newPos.latitude, newPos.longitude);
          },
          infoWindow: const gmaps.InfoWindow(title: "Your Location"),
          icon: gmaps.BitmapDescriptor.defaultMarkerWithHue(
            gmaps.BitmapDescriptor.hueBlue,
          ),
        );
      });

      _mapController?.animateCamera(
        gmaps.CameraUpdate.newCameraPosition(
          gmaps.CameraPosition(target: newLatLng, zoom: 16),
        ),
      );

      _updateBackendLatLng(lat, long);
    }
  }

  void _updateBackendLatLng(double lat, double long) {
    ref
        .read(authNotifierProvider.notifier)
        .updateLatLong(
          context,
          UpdateProfileRequest(lat: lat, long: long),
          onSuccess: () => log("Lat/Long updated successfully"),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          gmaps.GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (controller) => _mapController = controller,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            markers: _currentMarker != null ? {_currentMarker!} : {},
          ),
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: LocationTypeAheadField(
              googleApiKey: AppSecrets.googleApiKey,
              controller: _searchController,
              onLocationSelected: (newLat, newLng, description) {
                _searchController.text = description;
                _updateMarkerAndCamera(newLat, newLng);
              },
            ),
          ),
          Positioned(
            top: 80,
            left: 10,
            child: Container(
              width: 0.5.sw,
              height: 60,
              decoration: BoxDecoration(
                color: AppPalette.primaryColor,
                borderRadius: BorderRadius.circular(12),
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
                      // Optional: send availability status to backend
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
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
