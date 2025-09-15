import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/animation/fade_and_scale.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/dependency_injection/di_barrel.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/core/utils/app_static_data.dart';
import 'package:help_sum/src/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:help_sum/src/features/core/common/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:help_sum/src/features/core/consumer/booking/data/models/job_response_model.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/widgets/rich_booking_card.dart';
import 'package:help_sum/src/features/core/merchant/presentation/widgets/wallet_card.dart';
import 'package:help_sum/src/widgets/custom_loading_widget.dart';
import 'package:help_sum/src/widgets/custom_refresh_indicator.dart';
import 'package:help_sum/src/widgets/custom_search_field.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

import '../controller/all_bookings_provider.dart';

class AllBookingsPage extends ConsumerStatefulWidget {
  const AllBookingsPage({super.key});

  @override
  ConsumerState<AllBookingsPage> createState() => _AllBookingsPageState();
}

class _AllBookingsPageState extends ConsumerState<AllBookingsPage> {
  final ScrollController scrollController = ScrollController();
  int selectedIndex = 0;
  final TextEditingController searchController = TextEditingController();

  String selectedFilter = AppTexts.all;
  final List<String> filters = [
    AppTexts.all,
    AppTexts.completed,
    AppTexts.inProgress,
    AppTexts.pending,
    AppTexts.cancelled,
  ];

  String searchQuery = '';

  final Map<String, String> filterApiMap = {
    AppTexts.all: 'all',
    AppTexts.completed: 'completed',
    AppTexts.inProgress: 'in_progress',
    AppTexts.pending: 'pending',
    AppTexts.cancelled: 'cancelled',
  };

  static const List<String> jobTypes = AppStaticData.jobStatusTabs;
  late final WalletBloc _walletBloc;
  late final LoginBloc _loginBloc;

  @override
  void initState() {
    _walletBloc = sl();
    _loginBloc = sl();
    super.initState();
    scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  void _loadMore() {
    if (!mounted) return;
    final apiType = filterApiMap[selectedFilter] ?? 'all';
    final notifier = ref.read(allBookingsProvider(apiType).notifier);
    if (notifier.hasMore && !notifier.isLoadingMore) {
      notifier.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final apiType = filterApiMap[selectedFilter] ?? 'all';
    final jobsAsync = ref.watch(allBookingsProvider(apiType));
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _walletBloc),
        BlocProvider.value(value: _loginBloc),
      ],
      child: RefreshIndicator(
        onRefresh: () async {
          ref.read(allBookingsProvider(apiType).notifier).refresh();
        },
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            // Wallet card
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                child: BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, loginState) {
                    return BlocBuilder<WalletBloc, WalletState>(
                      builder: (context, walletState) {
                        final balance =
                            walletState is WalletLoaded
                                ? walletState.wallet.availableBalance
                                : 0.0;
                        final payment =
                            walletState is WalletLoaded
                                ? walletState.wallet.recentPayments
                                : null;

                        return FadeScaleTransitionWidget(
                          child: WalletCard(
                            balance: balance,
                            payment: payment,
                            isMerchant: false,
                            name:
                                "${loginState.userEntity?.firstName ?? ""} ${loginState.userEntity?.lastName ?? ""}",
                            userId: loginState.userEntity?.id ?? "",
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),

            // Sticky search + filter
            SliverPersistentHeader(
              floating: true,
              pinned: true,
              delegate: _StickyHeaderDelegate(
                minHeight: 80, // enough for search + filter
                maxHeight: 140,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      _searchField(),
                      10.verticalSpace,
                      _buildFilterButton(context),
                    ],
                  ),
                ),
              ),
            ),

            // Jobs list
            jobsAsync.when(
              data: (response) {
                final allJobs = response.data.data;
                final notifier = ref.read(
                  allBookingsProvider(apiType).notifier,
                );
                final jobs = _filterJobs(allJobs, searchQuery);

                if (jobs.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: CustomText(
                        text:
                            searchQuery.isNotEmpty
                                ? AppTexts.noServicesFound
                                : AppTexts.noBookingsFound,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  sliver: SliverList.separated(
                    itemCount: jobs.length + (notifier.hasMore ? 1 : 0),
                    itemBuilder: (c, i) {
                      if (i == jobs.length) {
                        return Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Center(child: CustomDotsLoader(size: 40)),
                        );
                      }

                      return RichBookingCard(
                        job: jobs[i],
                        showStatus: selectedIndex == 0,
                        onTap: () {
                          _navigateToJobDetailPage(context, jobs, i);
                        },
                      );
                    },
                    separatorBuilder: (context, index) => 10.verticalSpace,
                  ),
                );
              },
              loading:
                  () => SliverFillRemaining(
                    child: Center(child: CustomDotsLoader()),
                  ),
              error:
                  (e, st) => SliverFillRemaining(
                    child: Center(
                      child: CustomText(
                        text: e.toString(),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToJobDetailPage(
    BuildContext context,
    List<JobData> jobs,
    int i,
  ) async {
    bool? isRefresh = await context.pushNamed(
      AppRoutes.bookingTracker,
      extra: {'job': jobs[i], 'tabName': jobTypes[selectedIndex]},
    );
    if (isRefresh == true && mounted) {
      _fetchJobs(selectedIndex);
    }
  }

  Widget _searchField() {
    return CustomSearchField(
      controller: searchController,
      onChanged: (value) => _performSearch(value),
      onSearch: () => _performSearch(searchController.text),
    );
  }

  void _performSearch(String query) {
    if (!mounted) return;
    setState(() {
      searchQuery = query.toLowerCase().trim();
    });
  }

  Widget _buildFilterButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Expanded(
              child: CustomText(
                text: "Filter Bookings",
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () async {
                final result = await showModalBottomSheet<String>(
                  context: context,
                  builder: (ctx) => _buildFilterSheet(ctx),
                );
                if (result != null && result != selectedFilter) {
                  setState(() {
                    selectedFilter = result;
                    selectedIndex = filters.indexOf(result);
                  });
                  _fetchJobs(selectedIndex);
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(
                    text: selectedFilter,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: AppPalette.primaryColor,
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppPalette.primaryColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSheet(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children:
            filters.map((filter) {
              return ListTile(
                title: CustomText(
                  text: filter,
                  fontSize: 16.sp,
                  color:
                      filter == selectedFilter
                          ? AppPalette.primaryColor
                          : Colors.black,
                  fontWeight:
                      filter == selectedFilter
                          ? FontWeight.bold
                          : FontWeight.normal,
                ),
                onTap: () => Navigator.pop(context, filter),
                selected: filter == selectedFilter,
              );
            }).toList(),
      ),
    );
  }

  void _fetchJobs(int index) {
    if (!mounted) return;
    Future.microtask(() {
      if (!mounted) return;
      final newType = filterApiMap[filters[index]] ?? 'all';
      ref.invalidate(allBookingsProvider(newType));
    });
  }

  List<JobData> _filterJobs(List<JobData> jobs, String query) {
    if (query.isEmpty) return jobs;
    return jobs.where((job) {
      final title = job.title.toLowerCase();
      final description = job.description.toLowerCase();
      final serviceName = job.serviceId.name.toLowerCase();
      final merchantName =
          '${job.merchantId.firstName} ${job.merchantId.lastName}'
              .toLowerCase();
      final consumerName =
          '${job.consumerId.firstName} ${job.consumerId.lastName}'
              .toLowerCase();

      return title.contains(query) ||
          description.contains(query) ||
          serviceName.contains(query) ||
          merchantName.contains(query) ||
          consumerName.contains(query);
    }).toList();
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double minHeight;
  final double maxHeight;

  _StickyHeaderDelegate({
    required this.child,
    required this.minHeight,
    required this.maxHeight,
  });

  @override
  double get minExtent => 110;

  @override
  double get maxExtent => 120;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Colors.white, // keep sticky background
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _StickyHeaderDelegate oldDelegate) {
    return child != oldDelegate.child ||
        minHeight != oldDelegate.minHeight ||
        maxHeight != oldDelegate.maxHeight;
  }
}
