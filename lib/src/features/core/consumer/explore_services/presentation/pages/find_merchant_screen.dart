import 'dart:developer';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:help_sum/src/core/constants/app_dimensions.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/utils/app_utils.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/data/models/route/Booking_route_params.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/pages/merchant_list_tab_view.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/widgets/recommended_service_provider_card.dart';
import 'package:help_sum/src/widgets/custom_search_field.dart';
import 'package:help_sum/src/widgets/custom_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/controller/nearby_merchants_provider.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/controller/nearby_merchants_state.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/data/models/route/create_job_route_model.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/widgets/merchant_list_shimmer.dart';

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
  GoogleMapController? _mapController;
  final ScrollController _listScrollController = ScrollController();

  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(33.6844, 73.0479), // Example: Islamabad, Pakistan
    zoom: 14.0,
  );
  var showBottomButtons = false;
  var showRecommenededMerchants = false;

  // For demo: set these to your desired coordinates or get from user/location
  double lat = 0.0;
  double long = 0.0;

  @override
  void initState() {
    log("Category Id is ${widget.bookingRouteParams?.categoryId}");
    log("Service Id is ${widget.bookingRouteParams?.serviceId}");
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _searchController.addListener(_handleSearchInput);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final position = await AppUtils.getLocation();

      if (position != null) {
        lat = position.latitude;
        long = position.longitude;

        ref
            .read(nearbyMerchantsProvider.notifier)
            .fetchNearbyMerchants(
              lat: lat,
              long: long,
              serviceId: widget.bookingRouteParams?.serviceId,
            );
      } else {
        log("Location not available");
        CherryToast.info(
          title: Text("Location not available"),
          description: Text("Location is disabled on this device"),
        ).show(context);
      }
    });
  }

  void _handleTabSelection() {
    if (_tabController.index == 1) {
      final state = ref.read(nearbyMerchantsProvider);
      final serviceId = widget.bookingRouteParams?.serviceId;

      if (state is! NearbyMerchantsLoaded && lat != 0.0 && long != 0.0) {
        ref.invalidate(nearbyMerchantsProvider);
        ref
            .read(nearbyMerchantsProvider.notifier)
            .fetchNearbyMerchants(lat: lat, long: long, serviceId: serviceId);
      }
    }

    setState(() {});
  }

  void _handleSearchInput() {
    setState(() {
      if (_searchController.text.isNotEmpty && _tabController.index == 0) {
        showBottomButtons = true;
      } else {
        showBottomButtons = false;
        showRecommenededMerchants = false;
      }
    });
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
                  child: CustomSearchField(
                    horizontalPadding: 0,
                    controller: _searchController,
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
                      // Container(),
                      // Map Tab Content
                      Stack(
                        children: [
                          GoogleMap(
                            mapType: MapType.normal,
                            initialCameraPosition: _initialCameraPosition,
                            onMapCreated: (GoogleMapController controller) {
                              _mapController = controller;
                            },
                          ),
                        ],
                      ),
                      // List Tab Content
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
                                if (widget.bookingRouteParams != null) {
                                  context.pushNamed(
                                    AppRoutes.merchantProfile,
                                    extra: CreateJobRouteModel(
                                      merchantId: state.merchants.first.id,
                                      serviceId:
                                          widget.bookingRouteParams!.serviceId,
                                      categoryId:
                                          widget.bookingRouteParams!.categoryId,
                                      lat: lat.toString(),
                                      long: long.toString(),
                                    ),
                                  );
                                }
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
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                  if (showBottomButtons && _tabController.index == 0)
                    _buildBottomButtons(),
                  if (showRecommenededMerchants && _tabController.index == 0)
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
        if (showRecommenededMerchants == true) {
          showRecommenededMerchants = false;
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

  Widget _buildBottomButtons() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 10.h,
          horizontal: AppDimensions.paddingAllSides.w,
        ),
        color: AppPalette.backgroundColor,
        child: Row(
          children: [
            Expanded(
              child: CustomButton(
                text: AppTexts.search,
                textColor: Colors.white,
                onPressed: () {
                  setState(() {
                    showRecommenededMerchants = true;
                    showBottomButtons = false;
                  });
                },
                color: AppPalette.primaryColor,
              ),
            ),
            10.horizontalSpace,
            Expanded(
              child: CustomButton(
                text: AppTexts.bookImmediately,
                textColor: Colors.white,
                color: AppPalette.primaryColor,
                onPressed: () {},
              ),
            ),
          ],
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
