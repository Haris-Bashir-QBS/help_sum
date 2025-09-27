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
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/controller/category_provider.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/controller/category_state.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/controller/services_provider.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/controller/services_state.dart';
import 'package:help_sum/src/widgets/custom_text.dart';
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

  var showBottomButtons = false;
  var showRecommendedMerchants = false;
  double lat = 0.0;
  double long = 0.0;

  places_sdk.FlutterGooglePlacesSdk? _places;
  bool _locationPermissionGranted = false;
  bool _isInitializing = true;
  String? _selectedCategoryId;
  String? _selectedCategoryName;
  String? _selectedServiceId;
  String? _selectedServiceName;

  @override
  void initState() {
    log("Category Id is ${widget.bookingRouteParams?.categoryId}");
    log("Service Id is ${widget.bookingRouteParams?.serviceId}");
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _searchController.addListener(_handleSearchInput);
    _places = places_sdk.FlutterGooglePlacesSdk(AppSecrets.googleApiKey);
    _checkLocationPermission();

    _selectedCategoryId = widget.bookingRouteParams?.categoryId;
    _selectedCategoryName = widget.bookingRouteParams?.categoryName;
    _selectedServiceId = widget.bookingRouteParams?.serviceId;
    _selectedServiceName = widget.bookingRouteParams?.serviceName;

    // Start loading immediately without waiting for postFrameCallback
    _initializeLocationAndFetchData();
  }

  Future<void> _initializeLocationAndFetchData() async {
    try {
      final position = await AppUtils.getLocation();

      if (position != null && mounted) {
        setState(() {
          lat = position.latitude;
          long = position.longitude;
        });
        log("Fetched real location: Lat=$lat, Long=$long");

        // Fetch merchants immediately
        await ref
            .read(nearbyMerchantsProvider.notifier)
            .fetchNearbyMerchants(
              lat: lat,
              long: long,
              serviceId: _selectedServiceId,
              refresh: true,
            );

        // Set recommended merchants visibility after data is loaded
        if (mounted &&
            _tabController.index == 0 &&
            _searchController.text.isEmpty) {
          setState(() {
            showRecommendedMerchants = true;
            _isInitializing = false;
          });
        } else {
          setState(() {
            _isInitializing = false;
          });
        }
      } else {
        log("Location not available or permission denied.");
        if (mounted) {
          setState(() {
            _isInitializing = false;
          });
          CherryToast.info(
            title: const Text("Location not available"),
            description: const Text(
              "Please enable location services or grant permission.",
            ),
          ).show(context);
        }
      }
    } catch (e) {
      log("Error initializing location and data: $e");
      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
        // CherryToast.error(
        //   title: const Text("Error"),
        //   description: const Text("Failed to load location data."),
        // ).show(context);
      }
    }
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
      if (m.location.coordinates.length >= 2) // Longitude (index 0)
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
        final serviceId = _selectedServiceId;

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
                20.horizontalSpace,
                //  _backIcon(context),
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
                IconButton(
                  onPressed: _openFilterSheet,
                  icon: const Icon(Icons.tune_rounded),
                  color: AppPalette.blackColor,
                ),
              ],
            ),
            10.verticalSpace,
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Color(0xFFF5F7FA),
                borderRadius: BorderRadius.circular(18.r),
                //  border: Border.all(color: Colors.grey[300]!, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),

              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: AppPalette.whiteColor,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: AppPalette.primaryColor.withAlpha(100),
                    width: 0.3,
                  ),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorPadding: EdgeInsets.all(4.w),
                labelColor: Colors.white,
                unselectedLabelColor: AppPalette.greyColor,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                  color: AppPalette.primaryColor,
                ),
                unselectedLabelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                  color: AppPalette.primaryColor,
                ),
                dividerColor: Colors.transparent,
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                tabs: [
                  Tab(
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: CustomText(text: AppTexts.map),
                    ),
                  ),
                  Tab(
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: CustomText(text: AppTexts.list),
                    ),
                  ),
                ],
              ),
            ),
            Container(),
            // Option 1: Compact horizontal chips
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
              ).copyWith(top: 5.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if ((_selectedCategoryName ??
                              widget.bookingRouteParams?.categoryName) !=
                          null &&
                      (_selectedCategoryName ??
                                  widget.bookingRouteParams?.categoryName)
                              ?.isNotEmpty ==
                          true)
                    Container(
                      margin: EdgeInsets.only(right: 8.w),
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppPalette.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: AppPalette.primaryColor.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        (_selectedCategoryName ??
                            widget.bookingRouteParams!.categoryName!),
                        style: TextStyle(
                          color: AppPalette.primaryColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  if ((_selectedServiceName ??
                              widget.bookingRouteParams?.serviceName) !=
                          null &&
                      (_selectedServiceName ??
                                  widget.bookingRouteParams?.serviceName)
                              ?.isNotEmpty ==
                          true)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppPalette.primaryColor,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        (_selectedServiceName ??
                            widget.bookingRouteParams!.serviceName!),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            10.verticalSpace,
            Expanded(
              child: Stack(
                children: [
                  TabBarView(
                    controller: _tabController,
                    children: [
                      // Map Tab Content - Improved version
                      Builder(
                        builder: (context) {
                          final state = ref.watch(nearbyMerchantsProvider);
                          print(
                            "🗺️ Map Tab - State: ${state.runtimeType}, isInitializing: $_isInitializing, lat: $lat, long: $long",
                          );

                          // Show loading only during initialization or when no location
                          if (_isInitializing || (lat == 0.0 && long == 0.0)) {
                            print(
                              "🗺️ Showing loading - initialization or no location",
                            );
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          // Show error state with retry option
                          if (state is NearbyMerchantsError) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(state.message),
                                  10.verticalSpace,
                                  ElevatedButton(
                                    onPressed:
                                        () => _initializeLocationAndFetchData(),
                                    child: const Text('Retry'),
                                  ),
                                ],
                              ),
                            );
                          }

                          // Show map for all other states (loaded, loading with existing data)
                          final merchants =
                              state is NearbyMerchantsLoaded
                                  ? state.merchants
                                  : <MerchantModel>[];

                          print("🗺️ Map merchants count: ${merchants.length}");

                          return gmaps.GoogleMap(
                            mapType: gmaps.MapType.normal,
                            initialCameraPosition: gmaps.CameraPosition(
                              target: gmaps.LatLng(lat, long),
                              zoom: 14.0,
                            ),
                            onMapCreated: (
                              gmaps.GoogleMapController controller,
                            ) {
                              _mapController = controller;
                              // No need to animate here since initialCameraPosition is already set correctly
                            },
                            markers: generateMarkers(merchants, lat, long),
                          );
                        },
                      ),
                      // List Tab Content (existing logic)
                      Builder(
                        builder: (context) {
                          final state = ref.watch(nearbyMerchantsProvider);
                          print("📋 List Tab - State: ${state.runtimeType}");
                          if (state is NearbyMerchantsLoading ||
                              state is NearbyMerchantsInitial) {
                            print("📋 Showing shimmer");
                            return const MerchantListShimmer();
                          } else if (state is NearbyMerchantsError) {
                            print("📋 Showing error: ${state.message}");
                            return Center(child: Text(state.message));
                          } else if (state is NearbyMerchantsLoaded) {
                            print(
                              "📋 Showing ${state.merchants.length} merchants",
                            );
                            return MerchantTabView(
                              merchants: state.merchants,
                              scrollController: _listScrollController,
                              hasMore: state.hasMore,
                              onMerchantTap: (merchant) {
                                // Check if category and service are selected
                                final categoryId =
                                    _selectedCategoryId ??
                                    widget.bookingRouteParams?.categoryId;
                                final serviceId =
                                    _selectedServiceId ??
                                    widget.bookingRouteParams?.serviceId;
                                final hasCategory =
                                    categoryId != null && categoryId.isNotEmpty;
                                final hasService =
                                    serviceId != null && serviceId.isNotEmpty;

                                if (!hasCategory || !hasService) {
                                  // Show message to select category and service first
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Please select a category and service first',
                                      ),
                                      backgroundColor: AppPalette.primaryColor,
                                    ),
                                  );
                                  return;
                                }

                                context.pushNamed(
                                  AppRoutes.merchantProfile,
                                  extra: CreateJobRouteModel(
                                    merchantId: merchant.id,
                                    serviceId:
                                        _selectedServiceId ??
                                        widget.bookingRouteParams?.serviceId ??
                                        '',
                                    categoryId:
                                        _selectedCategoryId ??
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
                                      serviceId: _selectedServiceId,
                                    );
                              },
                              onRefresh: () async {
                                await ref
                                    .read(nearbyMerchantsProvider.notifier)
                                    .fetchNearbyMerchants(
                                      lat: lat,
                                      long: long,
                                      serviceId: _selectedServiceId,
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
                      selectedCategoryId: _selectedCategoryId,
                      selectedServiceId: _selectedServiceId,
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
        context.pop();
      },
    );
  }

  void _openFilterSheet() {
    // Clear services state first to avoid showing old services from previous sessions
    ref.read(servicesNotifierProvider.notifier).clearServices();

    // Trigger data loads outside widget build to avoid provider modification during build
    Future.microtask(() {
      ref
          .read(categoryNotifierProvider.notifier)
          .fetchCategories(refresh: true);
      if (_selectedCategoryId != null && _selectedCategoryId!.isNotEmpty) {
        ref
            .read(servicesNotifierProvider.notifier)
            .getServicesByCategory(
              categoryId: _selectedCategoryId!,
              refresh: true,
            );
      }
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: _FilterContent(
              selectedCategoryId: _selectedCategoryId,
              selectedServiceId: _selectedServiceId,
              onReset: () {
                setState(() {
                  _selectedCategoryId = null;
                  _selectedCategoryName = null;
                  _selectedServiceId = null;
                  _selectedServiceName = null;
                  // Update recommended merchants visibility based on current tab and search
                  if (_tabController.index == 0 &&
                      _searchController.text.isEmpty) {
                    showRecommendedMerchants = true;
                    print("🔄 Reset - showing recommended merchants");
                  } else {
                    showRecommendedMerchants = false;
                    print("🔄 Reset - hiding recommended merchants");
                  }
                });
                ref
                    .read(nearbyMerchantsProvider.notifier)
                    .fetchNearbyMerchants(
                      lat: lat,
                      long: long,
                      serviceId: null,
                      refresh: true,
                    );
                Navigator.of(context).pop();
              },
              onApply: (categoryId, categoryName, serviceId, serviceName) {
                setState(() {
                  _selectedCategoryId = categoryId;
                  _selectedCategoryName = categoryName;
                  _selectedServiceId = serviceId;
                  _selectedServiceName = serviceName;
                  // Update recommended merchants visibility based on current tab and search
                  if (_tabController.index == 0 &&
                      _searchController.text.isEmpty) {
                    showRecommendedMerchants = true;
                    print("🔄 Apply - showing recommended merchants");
                  } else {
                    showRecommendedMerchants = false;
                    print("🔄 Apply - hiding recommended merchants");
                  }
                });
                ref
                    .read(nearbyMerchantsProvider.notifier)
                    .fetchNearbyMerchants(
                      lat: lat,
                      long: long,
                      serviceId: serviceId,
                      refresh: true,
                    );
                Navigator.of(context).pop();
              },
            ),
          ),
        );
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
  final BookingRouteParams? bookingRouteParams;
  final String? selectedCategoryId;
  final String? selectedServiceId;

  const RecommendedMerchantsHorizontalList({
    super.key,
    required this.currentLat,
    required this.currentLong,
    this.bookingRouteParams,
    this.selectedCategoryId,
    this.selectedServiceId,
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
          height: 120.h,
          width: 100.sw,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            itemCount: state.merchants.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final merchant = state.merchants[index];
              return RecommendedServiceProviderCard(
                name: '${merchant.firstName} ${merchant.lastName}',
                rating:
                    merchant.rating != null
                        ? "${merchant.rating} (${merchant.reviews.length})"
                        : null,
                distance: "${merchant.distance ?? ""}m away",
                pricePerHour: '\$ ${merchant.hourlyRate} per hour',
                imageUrl:
                    merchant.image ??
                    (merchant.media.isNotEmpty ? merchant.media.first : ''),
                onTap: () {
                  // Check if category and service are selected
                  final categoryId =
                      selectedCategoryId ?? bookingRouteParams?.categoryId;
                  final serviceId =
                      selectedServiceId ?? bookingRouteParams?.serviceId;
                  final hasCategory =
                      categoryId != null && categoryId.isNotEmpty;
                  final hasService = serviceId != null && serviceId.isNotEmpty;

                  if (!hasCategory || !hasService) {
                    // Show message to select category and service first
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Please select a category and service first',
                        ),
                        backgroundColor: AppPalette.primaryColor,
                      ),
                    );
                    return;
                  }

                  log("Tapped recommended merchant: ${merchant.firstName}");
                  context.pushNamed(
                    AppRoutes.merchantProfile,
                    extra: CreateJobRouteModel(
                      merchantId: merchant.id,
                      serviceId: serviceId!,
                      categoryId: categoryId!,
                      lat: currentLat.toString(),
                      long: currentLong.toString(),
                    ),
                  );
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

class _FilterContent extends ConsumerStatefulWidget {
  final String? selectedCategoryId;
  final String? selectedServiceId;
  final void Function() onReset;
  final void Function(
    String? categoryId,
    String? categoryName,
    String? serviceId,
    String? serviceName,
  )
  onApply;

  const _FilterContent({
    required this.selectedCategoryId,
    required this.selectedServiceId,
    required this.onReset,
    required this.onApply,
  });

  @override
  ConsumerState<_FilterContent> createState() => _FilterContentState();
}

class _FilterContentState extends ConsumerState<_FilterContent> {
  String? _categoryId;
  String? _categoryName;
  String? _serviceId;
  String? _serviceName;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _categoryId = widget.selectedCategoryId;
    _serviceId = widget.selectedServiceId;
  }

  @override
  Widget build(BuildContext context) {
    final categoriesState = ref.watch(categoryNotifierProvider);
    final servicesState = ref.watch(servicesNotifierProvider);

    // Update loading state based on category and service loading states
    final isLoading =
        categoriesState is GetCategoriesLoading ||
        (servicesState is GetServicesLoading && _categoryId != null);

    if (isLoading != _isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _isLoading = isLoading;
          });
        }
      });
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 12.h),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          Center(
            child: Text(
              AppTexts.sortAndFilter,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
            ),
          ),
          12.verticalSpace,
          Text(
            AppTexts.categories,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
          ),
          8.verticalSpace,
          _buildCategories(categoriesState),
          12.verticalSpace,
          Text(
            AppTexts.services,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
          ),
          8.verticalSpace,
          _buildServices(servicesState),
          16.verticalSpace,
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : widget.onReset,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isLoading ? Colors.grey[200] : Colors.grey.shade300,
                    foregroundColor:
                        _isLoading ? Colors.grey[400] : Colors.black,
                  ),
                  child: Text(AppTexts.reset),
                ),
              ),
              12.horizontalSpace,
              Expanded(
                child: ElevatedButton(
                  onPressed:
                      (_isLoading || _categoryId == null || _serviceId == null)
                          ? null
                          : () => widget.onApply(
                            _categoryId,
                            _categoryName,
                            _serviceId,
                            _serviceName,
                          ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        (_isLoading ||
                                _categoryId == null ||
                                _serviceId == null)
                            ? Colors.grey[400]
                            : AppPalette.blackColor,
                    foregroundColor: Colors.white,
                  ),
                  child:
                      _isLoading
                          ? SizedBox(
                            height: 16.h,
                            width: 16.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                          : Text(AppTexts.apply),
                ),
              ),
            ],
          ),
          MediaQuery.of(context).viewInsets.bottom > 0
              ? SizedBox(height: 12.h)
              : 8.verticalSpace,
        ],
      ),
    );
  }

  Widget _buildCategories(CategoryState state) {
    if (state is GetCategoriesLoading) {
      return _buildCategoryShimmer();
    }
    if (state is GetCategoriesLoaded) {
      return Wrap(
        spacing: 8.w,
        runSpacing: 8.h,
        children:
            state.categories
                .map(
                  (c) => ChoiceChip(
                    showCheckmark: false,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        24,
                      ), // ✅ bigger radius
                    ),
                    selectedColor: AppPalette.primaryColor,
                    label: Text(
                      c.name,
                      style: TextStyle(
                        color:
                            _categoryId == c.id
                                ? Colors.white
                                : Colors.black, // ✅ text color
                      ),
                    ),
                    // label: Text(c.name),
                    selected: _categoryId == c.id,
                    onSelected: (_) {
                      setState(() {
                        _categoryId = c.id;
                        _categoryName = c.name;
                        _serviceId = null;
                        _serviceName = null;
                      });
                      // Clear services state first to avoid showing old services
                      ref
                          .read(servicesNotifierProvider.notifier)
                          .clearServices();
                      ref
                          .read(servicesNotifierProvider.notifier)
                          .getServicesByCategory(
                            categoryId: c.id,
                            refresh: true,
                          );
                    },
                  ),
                )
                .toList(),
      );
    }
    if (state is GetCategoriesError) {
      return Text(state.message);
    }
    return const SizedBox.shrink();
  }

  Widget _buildCategoryShimmer() {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: List.generate(6, (index) => _buildShimmerChip(index)),
    );
  }

  Widget _buildShimmerChip(int index) {
    return Container(
      height: 42.h,
      width: 80.w + (index % 3) * 20.w, // Vary width
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(20.r),
      ),
    );
  }

  Widget _buildServices(ServicesState state) {
    if (_categoryId == null) {
      return Text(AppTexts.selectCategoryFirst);
    }
    if (state is GetServicesLoading) {
      return _buildServiceShimmer();
    }
    if (state is GetServicesLoaded) {
      if (state.services.isEmpty) {
        return Text('No services available for this category');
      }
      return Wrap(
        spacing: 8.w,
        runSpacing: 8.h,
        children:
            state.services
                .map(
                  (s) => ChoiceChip(
                    showCheckmark: false,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        24,
                      ), // ✅ bigger radius
                    ),
                    selectedColor: AppPalette.primaryColor,
                    label: Text(
                      s.name,
                      style: TextStyle(
                        color: _serviceId == s.id ? Colors.white : Colors.black,
                      ),
                    ),
                    selected: _serviceId == s.id,
                    onSelected: (_) {
                      setState(() {
                        _serviceId = s.id;
                        _serviceName = s.name;
                      });
                    },
                  ),
                )
                .toList(),
      );
    }
    if (state is GetServicesError) {
      return Text(state.message);
    }
    return const SizedBox.shrink();
  }

  Widget _buildServiceShimmer() {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: List.generate(4, (index) => _buildShimmerChip(index)),
    );
  }
}
