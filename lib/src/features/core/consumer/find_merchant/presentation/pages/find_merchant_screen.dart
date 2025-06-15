import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:help_sum/src/core/constants/app_dimensions.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/features/core/consumer/find_merchant/presentation/widgets/recommended_service_provider_card.dart';
import 'package:help_sum/src/widgets/custom_search_field.dart';
import 'package:help_sum/src/widgets/custom_button.dart';
import 'package:help_sum/src/features/core/consumer/find_merchant/presentation/pages/merchant_list_tab_view.dart';

class FindMerchantScreen extends StatefulWidget {
  const FindMerchantScreen({super.key});

  @override
  State<FindMerchantScreen> createState() => _FindMerchantScreenState();
}

class _FindMerchantScreenState extends State<FindMerchantScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  GoogleMapController? _mapController;

  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(33.6844, 73.0479), // Example: Islamabad, Pakistan
    zoom: 14.0,
  );
  var showBottomButtons = false;
  var showRecommenededMerchants = false;
  final List<Map<String, String>> _dummyMerchants = [
    {
      'name': 'Michael',
      'rating': '4.3',
      'distance': '5.5 Kilo Meter',
      'price': '\$ 54 per hour',
      'imageUrl': 'https://picsum.photos/id/237/200/200',
    },
    {
      'name': 'James',
      'rating': '4.2',
      'distance': '5.5 Kilo Meter',
      'price': '\$ 54 per hour',
      'imageUrl': 'https://picsum.photos/id/238/200/200',
    },
    {
      'name': 'Ahmed',
      'rating': '4.2',
      'distance': '5.5 Kilo Meter',
      'price': '\$ 54 per hour',
      'imageUrl': 'https://picsum.photos/id/239/200/200',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _searchController.addListener(_handleSearchInput);
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
                IconButton(
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
                      print("dadsadsaa");
                      context.pop();
                    }
                  },
                ),
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
                      MerchantTabView(merchants: _dummyMerchants),
                    ],
                  ),
                  if (showBottomButtons && _tabController.index == 0)
                    _buildBottomButtons(),
                  if (showRecommenededMerchants && _tabController.index == 0)
                    _recommendedServiceproviders(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _recommendedServiceproviders() {
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: SizedBox(
        height: 150.h,
        child: ListView.separated(
          padding: EdgeInsets.only(left: 10.w),
          itemCount: _dummyMerchants.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final merchant = _dummyMerchants[index];
            return RecommendedServiceProviderCard(
              name: merchant['name']!,
              rating: merchant['rating']!,
              distance: merchant['distance']!,
              pricePerHour: merchant['price']!,
              imageUrl: merchant['imageUrl']!,
              onTap: () {},
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
