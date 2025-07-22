import 'dart:developer';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart'
    as places_sdk;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_secrets.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/core/utils/app_utils.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/data/models/route/Booking_route_params.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/data/models/route/create_job_route_model.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/controller/nearby_merchants_provider.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/controller/nearby_merchants_state.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/pages/merchant_list_tab_view.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/widgets/location_typeahead_field.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/widgets/merchant_list_shimmer.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/widgets/recommended_service_provider_card.dart';
import 'package:shimmer/shimmer.dart';

import '../../data/models/response/merchant_response_model.dart';

class FindMerchantScreen extends ConsumerStatefulWidget {
  final BookingRouteParams? bookingRouteParams;
  const FindMerchantScreen({super.key, this.bookingRouteParams});

  @override
  ConsumerState<FindMerchantScreen> createState() => _FindMerchantScreenState();
}

class _FindMerchantScreenState extends ConsumerState<FindMerchantScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  gmaps.GoogleMapController? _mapController;
  final ScrollController _listScrollController = ScrollController();

  static final gmaps.CameraPosition _initialCameraPosition =
      gmaps.CameraPosition(target: gmaps.LatLng(33.6844, 73.0479), zoom: 14.0);
  var showBottomButtons = false;
  var showRecommendedMerchants = false;
  double lat = 0.0;
  double long = 0.0;

  places_sdk.FlutterGooglePlacesSdk? _places;
  bool _locationPermissionGranted = false;

  @override
  void initState() {
    log("Category Id is ${widget.bookingRouteParams?.categoryId}");
    log("Service Id is ${widget.bookingRouteParams?.serviceId}");
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _searchController.addListener(_handleSearchInput);
    _places = places_sdk.FlutterGooglePlacesSdk(AppSecrets.googleApiKey);
    _checkLocationPermission(); // Check and request permission first

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final position = await AppUtils.getLocation();

      if (position != null) {
        setState(() {
          lat = position.latitude;
          long = position.longitude;
        });
        log("Fetched real location: Lat=$lat, Long=$long");

        // Animate map to current location if controller is available
        if (_mapController != null) {
          _mapController!.animateCamera(
            gmaps.CameraUpdate.newCameraPosition(
              gmaps.CameraPosition(
                target: gmaps.LatLng(lat, long),
                zoom: 14.0, // Adjust zoom level as needed
              ),
            ),
          );
        }

        ref.invalidate(nearbyMerchantsProvider);
        ref
            .read(nearbyMerchantsProvider.notifier)
            .fetchNearbyMerchants(
              lat: lat, // Use real latitude
              long: long, // Use real longitude
              serviceId: widget.bookingRouteParams?.serviceId,
              refresh: true, // force refresh
            );
        // Initially show recommended merchants on map tab if no search
        if (_tabController.index == 0 && _searchController.text.isEmpty) {
          setState(() {
            showRecommendedMerchants = true;
          });
        }
      } else {
        log("Location not available or permission denied.");
        if (!mounted) return;
        CherryToast.info(
          title: const Text("Location not available"),
          description: const Text(
            "Please enable location services or grant permission.",
          ),
        ).show(context);
      }
    });
  }

  Set<gmaps.Marker> generateMarkers(
    List<MerchantModel> merchants,
    double lat,
    double long,
  ) {
    final Set<gmaps.Marker> markers = {};

    // Add user's current location marker if lat/long are valid (not default 0.0)
    if (lat != 0.0 && long != 0.0) {
      markers.add(
        gmaps.Marker(
          markerId: const gmaps.MarkerId("user_location"),
          position: gmaps.LatLng(lat, long),
          infoWindow: const gmaps.InfoWindow(title: "Your Location"),
          icon: gmaps.BitmapDescriptor.defaultMarkerWithHue(
            gmaps.BitmapDescriptor.hueBlue,
          ),
        ),
      );
    }

    // Add merchant markers
    for (var m in merchants) {
      // Ensure coordinates array has at least 2 elements and they are not null
      if (m.location.coordinates.length >= 2 &&
          m.location.coordinates[1] != null && // Latitude (index 1)
          m.location.coordinates[0] != null) // Longitude (index 0)
      {
        markers.add(
          gmaps.Marker(
            markerId: gmaps.MarkerId(m.id),
            position: gmaps.LatLng(
              m.location.coordinates[1], // Latitude
              m.location.coordinates[0], // Longitude
            ),
            infoWindow: gmaps.InfoWindow(
              onTap: () {
                context.pushNamed(
                  AppRoutes.merchantProfile,
                  extra: CreateJobRouteModel(
                    merchantId: m.id,
                    serviceId: widget.bookingRouteParams?.serviceId ?? '',
                    categoryId: widget.bookingRouteParams?.categoryId ?? '',
                    lat: lat.toString(),
                    long: long.toString(),
                  ),
                );
              },
              title: "${m.firstName} ${m.lastName}",
              snippet: "\$${m.hourlyRate}/hr",
            ),
          ),
        );
      }
    }
    return markers;
  }

  void _handleTabSelection() {
    setState(() {
      if (_tabController.index == 0) {
        // Map tab selected
        if (_searchController.text.isEmpty) {
          showRecommendedMerchants = true; // Show recommended if no search
        } else {
          showRecommendedMerchants = false; // Hide if search is active
        }
        showBottomButtons = _searchController.text.isNotEmpty;
      } else {
        // List tab selected
        showRecommendedMerchants = false; // Hide recommended on list tab
        showBottomButtons = false;
        final state = ref.read(nearbyMerchantsProvider);
        final serviceId = widget.bookingRouteParams?.serviceId;

        // Only fetch if not already loaded and location is available
        if (state is! NearbyMerchantsLoaded && lat != 0.0 && long != 0.0) {
          ref.invalidate(nearbyMerchantsProvider);
          ref
              .read(nearbyMerchantsProvider.notifier)
              .fetchNearbyMerchants(lat: lat, long: long, serviceId: serviceId);
        }
      }
    });
  }

  void _handleSearchInput() {
    setState(() {
      if (_searchController.text.isNotEmpty && _tabController.index == 0) {
        showBottomButtons = true;
        showRecommendedMerchants = false; // Hide recommended when searching
      } else {
        showBottomButtons = false;
        // If search is cleared and on map tab, show recommended again
        if (_tabController.index == 0 && _searchController.text.isEmpty) {
          showRecommendedMerchants = true;
        } else {
          showRecommendedMerchants = false;
        }
      }
    });
  }

  Future<void> _checkLocationPermission() async {
    final status = await geolocator.Geolocator.checkPermission();
    if (status == geolocator.LocationPermission.always ||
        status == geolocator.LocationPermission.whileInUse) {
      _locationPermissionGranted = true;
    } else {
      final result = await geolocator.Geolocator.requestPermission();
      _locationPermissionGranted =
          result == geolocator.LocationPermission.always ||
          result == geolocator.LocationPermission.whileInUse;

      if (!mounted)
        return; // Check if the widget is still mounted after async gap
      if (!_locationPermissionGranted) {
        CherryToast.info(
          title: const Text("Location Permission Denied"),
          description: const Text(
            "Please grant location access to use this feature.",
          ),
        ).show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            10.verticalSpace,
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _backIcon(context),
                Expanded(
                  child: LocationTypeAheadField(
                    googleApiKey: AppSecrets.googleApiKey,
                    controller: _searchController,
                    onLocationSelected: (newLat, newLng, description) {
                      setState(() {
                        lat = newLat;
                        long = newLng;
                        _searchController.text = description;
                        showRecommendedMerchants =
                            false; // Hide on location select
                      });
                      ref.invalidate(nearbyMerchantsProvider);
                      ref
                          .read(nearbyMerchantsProvider.notifier)
                          .fetchNearbyMerchants(
                            lat: lat,
                            long: long,
                            serviceId: widget.bookingRouteParams?.serviceId,
                            refresh: true,
                          );
                      // Animate map to new selected location
                      Future.delayed(const Duration(milliseconds: 1000), () {
                        if (_mapController != null) {
                          log(
                            "Animating map to new selected location: $newLat, $newLng",
                          );
                          _mapController!.animateCamera(
                            gmaps.CameraUpdate.newCameraPosition(
                              gmaps.CameraPosition(
                                target: gmaps.LatLng(newLat, newLng),
                                zoom: 16.0,
                              ),
                            ),
                          );
                        }
                      });
                    },
                  ),
                ),
                10.horizontalSpace,
              ],
            ),
            10.verticalSpace,
            TabBar(
              controller: _tabController,
              indicatorColor: AppPalette.primaryColor,
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: AppPalette.primaryColor,
              unselectedLabelColor: AppPalette.greyColor,
              tabs: const [Tab(text: AppTexts.map), Tab(text: AppTexts.list)],
            ),
            Expanded(
              child: Stack(
                children: [
                  TabBarView(
                    controller: _tabController,
                    children: [
                      // Map Tab Content
                      Builder(
                        builder: (context) {
                          final state = ref.watch(nearbyMerchantsProvider);
                          // Show a message if location is not yet available or permission is denied
                          if (lat == 0.0 &&
                              long == 0.0 &&
                              !_locationPermissionGranted) {
                            return const Center(
                              child: LinearProgressIndicator(),
                            );
                          }
                          if (state is NearbyMerchantsLoading ||
                              state is NearbyMerchantsInitial) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (state is NearbyMerchantsLoaded) {
                            return gmaps.GoogleMap(
                              mapType: gmaps.MapType.normal,
                              // Set initial camera position to current location if available, otherwise default
                              initialCameraPosition:
                                  (lat != 0.0 && long != 0.0)
                                      ? gmaps.CameraPosition(
                                        target: gmaps.LatLng(lat, long),
                                        zoom: 14.0,
                                      )
                                      : _initialCameraPosition, // Fallback
                              onMapCreated: (
                                gmaps.GoogleMapController controller,
                              ) {
                                _mapController = controller;
                                // Animate to user's real location if available right after map creation
                                if (lat != 0.0 && long != 0.0) {
                                  log(
                                    "Map created, animating to user location: $lat, $long",
                                  );
                                  _mapController!.animateCamera(
                                    gmaps.CameraUpdate.newCameraPosition(
                                      gmaps.CameraPosition(
                                        target: gmaps.LatLng(lat, long),
                                        zoom: 14.0,
                                      ),
                                    ),
                                  );
                                }
                              },
                              markers: generateMarkers(
                                state.merchants,
                                lat,
                                long,
                              ),
                            );
                          }
                          return const SizedBox.shrink(); // Fallback for other states
                        },
                      ),
                      // List Tab Content (existing logic)
                      Builder(
                        builder: (context) {
                          final state = ref.watch(nearbyMerchantsProvider);
                          if (state is NearbyMerchantsLoading ||
                              state is NearbyMerchantsInitial) {
                            return const MerchantListShimmer();
                          } else if (state is NearbyMerchantsError) {
                            return Center(child: Text(state.message));
                          } else if (state is NearbyMerchantsLoaded) {
                            return MerchantTabView(
                              merchants: state.merchants,
                              scrollController: _listScrollController,
                              hasMore: state.hasMore,
                              onMerchantTap: (merchant) {
                                context.pushNamed(
                                  AppRoutes.merchantProfile,
                                  extra: CreateJobRouteModel(
                                    merchantId: merchant.id,
                                    serviceId:
                                        widget.bookingRouteParams?.serviceId ??
                                        '',
                                    categoryId:
                                        widget.bookingRouteParams?.categoryId ??
                                        '',
                                    lat: lat.toString(),
                                    long: long.toString(),
                                  ),
                                );
                              },
                              onEndReached: () {
                                ref
                                    .read(nearbyMerchantsProvider.notifier)
                                    .loadMore(
                                      lat: lat,
                                      long: long,
                                      serviceId:
                                          widget.bookingRouteParams?.serviceId,
                                    );
                              },
                              onRefresh: () async {
                                await ref
                                    .read(nearbyMerchantsProvider.notifier)
                                    .fetchNearbyMerchants(
                                      lat: lat,
                                      long: long,
                                      serviceId:
                                          widget.bookingRouteParams?.serviceId,
                                      refresh: true,
                                    );
                              },
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),

                  // Use the new widget here, outside of TabBarView's builder
                  if (showRecommendedMerchants && _tabController.index == 0)
                    RecommendedMerchantsHorizontalList(
                      currentLat: lat,
                      currentLong: long,
                      bookingRouteParams: widget.bookingRouteParams,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconButton _backIcon(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new, size: 25),
      color: AppPalette.blackColor,
      onPressed: () {
        if (showRecommendedMerchants == true) {
          // If recommended merchants are showing, hide them first
          setState(() {
            showRecommendedMerchants = false;
            showBottomButtons =
                false; // Also hide bottom buttons if they were linked
          });
        } else if (showBottomButtons == true) {
          // If search-related buttons are showing, hide them and clear search
          setState(() {
            showBottomButtons = false;
            _searchController.clear();
          });
        } else {
          // Otherwise, pop the screen
          context.pop();
        }
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _mapController?.dispose(); // Dispose map controller
    super.dispose();
  }
}

class RecommendedMerchantsHorizontalList extends ConsumerWidget {
  final double currentLat;
  final double currentLong;
  final BookingRouteParams?
  bookingRouteParams; // Pass this if needed for navigation logic

  const RecommendedMerchantsHorizontalList({
    super.key,
    required this.currentLat,
    required this.currentLong,
    this.bookingRouteParams,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(nearbyMerchantsProvider);

    if (state is NearbyMerchantsLoaded && state.merchants.isNotEmpty) {
      return Positioned(
        bottom: 20,
        left: 0,
        right: 0,
        child: SizedBox(
          height: 150.h,
          width: 100.sw,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            itemCount: state.merchants.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final merchant = state.merchants[index];
              return RecommendedServiceProviderCard(
                name: '${merchant.firstName} ${merchant.lastName}',
                rating: null, // You might want to fetch/display actual ratings
                distance:
                    'N/A', // You might want to calculate/display actual distance
                pricePerHour: '\$ ${merchant.hourlyRate} per hour',
                imageUrl:
                    merchant.image ??
                    (merchant.media.isNotEmpty ? merchant.media.first : ''),
                onTap: () {
                  if (bookingRouteParams != null) {
                    log("Tapped recommended merchant: ${merchant.firstName}");
                    context.pushNamed(
                      AppRoutes.merchantProfile,
                      extra: CreateJobRouteModel(
                        merchantId: merchant.id,
                        serviceId: bookingRouteParams!.serviceId,
                        categoryId: bookingRouteParams!.categoryId,
                        lat: currentLat.toString(),
                        long: currentLong.toString(),
                      ),
                    );
                  }
                },
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return 15.horizontalSpace;
            },
          ),
        ),
      );
    } else if (state is NearbyMerchantsLoading) {
      // Show shimmer or loading indicator
      return Positioned(
        bottom: 20,
        left: 0,
        right: 0,
        child: SizedBox(
          height: 150.h,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            itemCount: 3, // Show a few shimmer cards
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return const RecommendedServiceProviderCardShimmer();
            },
            separatorBuilder: (BuildContext context, int index) {
              return 15.horizontalSpace;
            },
          ),
        ),
      );
    }
    return const SizedBox.shrink(); // Hide if no merchants or error state
  }
}

class RecommendedServiceProviderCardShimmer extends StatelessWidget {
  const RecommendedServiceProviderCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.w, // Match the width of your actual card
      height: 150.h, // Match the height of your actual card
      decoration: BoxDecoration(
        color: Colors.white, // A base color for the shimmer effect
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!, // Lighter grey for the base
        highlightColor:
            Colors.grey[100]!, // Even lighter grey for the highlight
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Placeholder for the image
            Container(
              width: double.infinity,
              height: 80.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(10.r)),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Placeholder for name
                  Container(width: 100.w, height: 10.h, color: Colors.white),
                  5.verticalSpace,
                  // Placeholder for price/distance
                  Container(width: 80.w, height: 10.h, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
