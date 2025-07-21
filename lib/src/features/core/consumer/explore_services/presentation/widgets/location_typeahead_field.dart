import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart'
    as places_sdk;
import 'package:geolocator/geolocator.dart' as geolocator;

class LocationTypeAheadField extends StatelessWidget {
  final String googleApiKey;
  final TextEditingController controller;
  final void Function(double lat, double lng, String description)
  onLocationSelected;

  const LocationTypeAheadField({
    super.key,
    required this.googleApiKey,
    required this.controller,
    required this.onLocationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final places = places_sdk.FlutterGooglePlacesSdk(googleApiKey);

    return TypeAheadField<places_sdk.AutocompletePrediction?>(
      controller: controller,
      suggestionsCallback: (pattern) async {
        if (pattern.isEmpty) return <places_sdk.AutocompletePrediction?>[];
        final result = await places.findAutocompletePredictions(pattern);
        return <places_sdk.AutocompletePrediction?>[
          null,
          ...result.predictions,
        ];
      },

      itemBuilder: (context, suggestion) {
        if (suggestion == null) {
          return const ListTile(
            leading: Icon(Icons.my_location, color: Colors.blue),
            title: Text('Use current location'),
          );
        }
        return ListTile(
          leading: const Icon(Icons.location_on),
          title: Text(suggestion.fullText ?? ''),
        );
      },

      onSelected: (suggestion) async {
        double? newLat, newLng;
        String description = '';

        if (suggestion == null) {
          final status = await geolocator.Geolocator.checkPermission();
          bool granted =
              status == geolocator.LocationPermission.always ||
              status == geolocator.LocationPermission.whileInUse;
          if (!granted) {
            final result = await geolocator.Geolocator.requestPermission();
            granted =
                result == geolocator.LocationPermission.always ||
                result == geolocator.LocationPermission.whileInUse;
          }

          if (granted) {
            final pos = await geolocator.Geolocator.getCurrentPosition();
            newLat = pos.latitude;
            newLng = pos.longitude;
            description = 'Current Location';
            controller.text = description;
          }
        } else {
          final details = await places.fetchPlace(
            suggestion.placeId,
            fields: [places_sdk.PlaceField.Location],
          );
          final loc = details.place?.latLng;
          if (loc != null) {
            newLat = loc.lat;
            newLng = loc.lng;
            description = suggestion.fullText ?? '';
            controller.text = description;
          }
        }

        if (newLat != null && newLng != null) {
          onLocationSelected(newLat, newLng, description);
          FocusScope.of(context).unfocus();
        }
      },

      builder: (context, fieldController, focusNode) {
        return TextField(
          controller: fieldController, // Use `fieldController` here
          focusNode: focusNode,
          decoration: InputDecoration(
            hintText: 'Search location',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        );
      },
    );
  }
}
