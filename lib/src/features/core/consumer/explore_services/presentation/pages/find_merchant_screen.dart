import 'dart:developer';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_secrets.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/utils/app_utils.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/data/models/route/Booking_route_params.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/pages/merchant_list_tab_view.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/widgets/recommended_service_provider_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/controller/nearby_merchants_provider.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/controller/nearby_merchants_state.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/data/models/route/create_job_route_model.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/widgets/merchant_list_shimmer.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart'
    as places_sdk;
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/widgets/location_typeahead_field.dart';

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
    _checkLocationPermission();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final position = await AppUtils.getLocation();

      if (position != null) {
        lat = position.latitude;
        long = position.longitude;
        ref.invalidate(nearbyMerchantsProvider);
        ref
            .read(nearbyMerchantsProvider.notifier)
            .fetchNearbyMerchants(
              lat: lat,
              long: long,
              serviceId: widget.bookingRouteParams?.serviceId,
              refresh: true, // force refresh
            );
      } else {
        log("Location not available");
        if (!mounted) return;
        CherryToast.info(
          title: Text("Location not available"),
          description: Text("Location is disabled on this device"),
        ).show(context);
      }
    });
  }

  void _handleTabSelection() {
    setState(() {});
  }

  void _handleSearchInput() {
    setState(() {
      if (_searchController.text.isNotEmpty && _tabController.index == 0) {
        showBottomButtons = true;
      } else {
        showBottomButtons = false;
        showRecommendedMerchants = false;
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
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<NearbyMerchantsState>(nearbyMerchantsProvider, (prev, next) {
      // if (next is NearbyMerchantsLoaded) {
      //   _updateMarkers(next.merchants);
      // }
    });
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
                      Future.delayed(const Duration(milliseconds: 1000), () {
                        if (_mapController != null) {
                          print("Hereeeeeeeeeee animatiinggggg ");
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
                          if (state is NearbyMerchantsLoading ||
                              lat == 0.0 && long == 0.0) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          // Show only the map, no horizontal merchant card list
                          return gmaps.GoogleMap(
                            mapType: gmaps.MapType.normal,
                            initialCameraPosition: _initialCameraPosition,
                            onMapCreated: (
                              gmaps.GoogleMapController controller,
                            ) {
                              _mapController = controller;
                            },
                            // No markers
                          );
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

                  if (showRecommendedMerchants && _tabController.index == 0)
                    _recommendedServiceProviders(),
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
          showRecommendedMerchants = false;
          showBottomButtons = true;
          setState(() {});
        } else if (showBottomButtons == true) {
          showBottomButtons = false;
          _searchController.clear();
          setState(() {});
        } else {
          context.pop();
        }
      },
    );
  }

  Widget _recommendedServiceProviders() {
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: SizedBox(
        height: 150.h,
        child: ListView.separated(
          padding: EdgeInsets.only(left: 10.w),
          itemCount:
              (ref.watch(nearbyMerchantsProvider) is NearbyMerchantsLoaded)
                  ? (ref.watch(nearbyMerchantsProvider)
                          as NearbyMerchantsLoaded)
                      .merchants
                      .length
                  : 0,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final state = ref.watch(nearbyMerchantsProvider);
            final merchant =
                (state is NearbyMerchantsLoaded)
                    ? state.merchants[index]
                    : null;
            if (merchant == null) return const SizedBox.shrink();
            return RecommendedServiceProviderCard(
              name: '${merchant.firstName} ${merchant.lastName}',
              rating: null,
              distance: 'N/A',
              pricePerHour: '\$ ${merchant.hourlyRate} per hour',
              imageUrl:
                  merchant.image ??
                  (merchant.media.isNotEmpty ? merchant.media.first : ''),
              onTap: () {
                if (widget.bookingRouteParams != null) {
                  print("Hereeeeee");
                  context.pushNamed(
                    AppRoutes.createRequest,
                    extra: CreateJobRouteModel(
                      merchantId: merchant.id,
                      serviceId: widget.bookingRouteParams!.serviceId,
                      categoryId: widget.bookingRouteParams!.categoryId,
                      lat: lat.toString(),
                      long: long.toString(),
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
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
