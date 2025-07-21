import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    target: LatLng(33.6844, 73.0479), // Example: Islamabad, Pakistan
    zoom: 14.0,
  );

  bool siwtchValue = false;

  @override
  void initState() {
    _updateLatLng();
    super.initState();
  }

  _updateLatLng() async {
    // final LatLng ne  wLatLng = LatLng(
    //   33.6844,
    //   73.0479,
    // ); // Example: Islamabad, Pakistan

    if (await Geolocator.isLocationServiceEnabled()) {
      Geolocator.getCurrentPosition(
            locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
          )
          .then((position) {
            final LatLng newLatLng = LatLng(
              position.latitude,
              position.longitude,
            );
            ref
                .read(authNotifierProvider.notifier)
                .updateLatLong(
                  context,

                  UpdateProfileRequest(
                    // lat: newLatLng.latitude,
                    // long: newLatLng.longitude,
                    lat: 24.900,
                    long: 67.1060,
                  ),

                  onSuccess: () {
                    debugPrint("LatLng updated successfully");
                  },
                );
          })
          .catchError((error) {
            debugPrint("Error getting location: $error");
          });
    } else {
      debugPrint("Location services are disabled.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _searchField(),
        GoogleMap(initialCameraPosition: _initialCameraPosition),
        Container(
          width: .42.sw,
          height: 60,
          decoration: BoxDecoration(
            color: AppPalette.primaryColor,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(12),

              bottomRight: Radius.circular(12),
            ),
          ),
          child: Row(
            children: [
              SizedBox(width: 15),
              CupertinoSwitch(
                thumbColor: Colors.white,
                activeTrackColor: Colors.white.withValues(alpha: .4),
                inactiveTrackColor: Colors.white.withValues(alpha: .4),
                value: siwtchValue,
                onChanged: (v) {
                  setState(() {
                    siwtchValue = !siwtchValue;
                  });
                },
              ),

              SizedBox(width: 10),
              CustomText(
                text: "Available",
                fontWeight: FontWeight.w500,
                color: AppPalette.fillColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Container _searchField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: CustomTextFormField(
              hint: 'Search...',
              prefixIcon: Icons.search,
            ),
          ),
          SizedBox(width: 10),

          Icon(Icons.bookmark, size: 30, color: AppPalette.primaryColor),
        ],
      ),
    );
  }
}
