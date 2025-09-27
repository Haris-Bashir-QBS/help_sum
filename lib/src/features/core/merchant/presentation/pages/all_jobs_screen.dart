import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/animation/fade_and_scale.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/dependency_injection/di_barrel.dart';
import 'package:help_sum/src/core/enums/job_status.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/core/utils/app_static_data.dart';
import 'package:help_sum/src/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:help_sum/src/features/core/common/main_navigation/domain/model/job_model.dart';
import 'package:help_sum/src/features/core/consumer/booking/data/models/job_response_model.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/widgets/rich_booking_card.dart';
import 'package:help_sum/src/features/core/merchant/presentation/controller/job_request_provider.dart';
import 'package:help_sum/src/features/core/merchant/presentation/controller/job_request_states.dart';
import 'package:help_sum/src/features/core/merchant/presentation/widgets/wallet_card.dart';
import 'package:help_sum/src/features/core/common/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:help_sum/src/widgets/custom_loading_widget.dart';
import 'package:help_sum/src/widgets/custom_search_field.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class AllJobsScreen extends ConsumerStatefulWidget {
  const AllJobsScreen({super.key});

  @override
  ConsumerState<AllJobsScreen> createState() => _AllJobsScreenState();
}

class _AllJobsScreenState extends ConsumerState<AllJobsScreen> {
  final ScrollController scrollController = ScrollController();
  int selectedIndex = 0;
  List<JobModel> jobs = [];
  late final LoginBloc _loginBloc;
  late final WalletBloc _walletBloc;
  final TextEditingController searchController = TextEditingController();

  String selectedFilter = AppTexts.all;
  final List<String> filters = [
    AppTexts.all,
    AppTexts.pending,
    AppTexts.onGoing,
    AppTexts.waitingConfirmation,
    AppTexts.waitingPayment,
    AppTexts.completed,
    AppTexts.cancelled,
  ];

  String searchQuery = '';

  final Map<String, String> filterApiMap = {
    AppTexts.all: 'all',
    AppTexts.onGoing: 'on going',
    AppTexts.waitingConfirmation: 'waiting_confirmation',
    AppTexts.waitingPayment: 'waiting_payment',
    AppTexts.completed: 'completed',
    AppTexts.cancelled: 'cancelled',
  };

  @override
  void initState() {
    _loginBloc = sl();
    _walletBloc = sl();

    _walletBloc.add(LoadWallet());
    jobs = AppStaticData.dummyJobs;
    ref
        .read(merchantJobsNotifierProvider.notifier)
        .getAllJobsByType(jobType: AppStaticData.jobStatusTabs.first);

    scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      final apiType = filterApiMap[selectedFilter] ?? 'all';
      ref
          .read(merchantJobsNotifierProvider.notifier)
          .loadMore(jobType: apiType);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(merchantJobsNotifierProvider);
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _loginBloc),
        BlocProvider.value(value: _walletBloc),
      ],
      child: RefreshIndicator(
        onRefresh: () async {
          final apiType = filterApiMap[selectedFilter] ?? 'all';
          ref
              .read(merchantJobsNotifierProvider.notifier)
              .getAllJobsByType(jobType: apiType, refresh: true);

          _walletBloc.add(LoadWallet());
        },
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
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
                            isMerchant: true,
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
            SliverPersistentHeader(
              floating: true,
              pinned: true, // 👈 makes it stick
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

            // Job list section
            _jobListSliver(state),
          ],
        ),
      ),
    );
  }

  Widget _jobListSliver(MerchantJobsState state) {
    if (state is MerchantJobsLoading || state is MerchantJobsInitial) {
      return SliverFillRemaining(child: Center(child: CustomDotsLoader()));
    } else if (state is MerchantJobsError) {
      return SliverFillRemaining(
        child: Center(child: CustomText(text: state.message)),
      );
    } else if (state is MerchantJobsLoaded) {
      // Use the accumulated jobs from the notifier instead of just the current response
      final notifier = ref.read(merchantJobsNotifierProvider.notifier);
      final allJobs = notifier.jobs;

      // Filter jobs based on search query
      final jobs = _filterJobs(allJobs, searchQuery);

      if (jobs.isEmpty) {
        return SliverFillRemaining(
          child: Center(
            child: CustomText(
              text:
                  searchQuery.isNotEmpty
                      ? AppTexts.noServicesFound
                      : "No Jobs Found",
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }

      return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            if (index < jobs.length) {
              final job = jobs[index];
              return Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: RichBookingCard(
                  job: job,
                  isMerchant: true,
                  showStatus: selectedIndex == 0,
                  onTap: () => _navigateToJobDetailScreen(job),
                ),
              );
            } else if (index == jobs.length && state.hasMore) {
              // Show loading indicator at the bottom
              return Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CustomDotsLoader()),
              );
            }
            return null;
          }, childCount: jobs.length + (state.hasMore ? 1 : 0)),
        ),
      );
    }

    return const SliverToBoxAdapter(child: SizedBox());
  }

  void _navigateToJobDetailScreen(JobData? job) async {
    bool? isRefresh = await context.pushNamed(
      AppRoutes.bookingTracker,
      extra: {
        'job': job?.id,
        'tabName': AppStaticData.jobStatusTabs[selectedIndex],
      },
    );

    // bool? isRefresh = await context.pushNamed(AppRoutes.rateScreen, extra: job);
    if (isRefresh == true && mounted) {
      _fetchJobs();
    }
  }

  String getJobString(JobStatus job) {
    log(job.name);
    switch (job) {
      case JobStatus.ongoing:
      case JobStatus.in_progress:
        return "In-Progress";
      case JobStatus.approved:
      case JobStatus.accepted:
        return "Approved";
      case JobStatus.completed:
        return "Completed";
      case JobStatus.waitingConfirmation:
        return "Waiting Confirmation";
      case JobStatus.waitingPayment:
        return "Waiting Payment";
      case JobStatus.cancelled:
        return "Cancelled";
      case JobStatus.all:
        return AppTexts.all;
      case JobStatus.pending:
        return AppTexts.pending;
      case JobStatus.rejected:
        return AppTexts.rejected;
    }
  }

  Color getJobColor(JobStatus job) {
    switch (job) {
      case JobStatus.ongoing:
      case JobStatus.in_progress:
      case JobStatus.pending:
        return Color(0xFFFFC680);
      case JobStatus.approved:
      case JobStatus.accepted:
      case JobStatus.completed:
        return Color(0xFFAFFFA8);
      case JobStatus.waitingConfirmation:
      case JobStatus.waitingPayment:
        return Color(0xFFFFC680);
      case JobStatus.cancelled:
      case JobStatus.rejected:
        return Color(0xFFFF0000);
      case JobStatus.all:
        return Colors.transparent;
    }
  }

  Widget _searchField() {
    return CustomSearchField(
      horizontalPadding: 0,
      controller: searchController,
      onChanged: (value) {
        // Implement search logic here
        _performSearch(value);
      },
      onSearch: () {
        // Implement search on search button tap
        _performSearch(searchController.text);
      },
    );
  }

  void _performSearch(String query) {
    if (!mounted) return;

    setState(() {
      searchQuery = query.toLowerCase().trim();
    });
  }

  Widget _buildFilterButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Row(
          children: [
            Expanded(
              child: CustomText(
                text: "Filter Jobs",
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
                  _fetchJobs();
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

  void _fetchJobs() {
    if (!mounted) return;

    Future.microtask(() {
      if (!mounted) return;
      final apiType = filterApiMap[selectedFilter] ?? 'all';
      ref
          .read(merchantJobsNotifierProvider.notifier)
          .getAllJobsByType(jobType: apiType, refresh: true);
    });
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
    return Container(color: Colors.white, child: child);
  }

  @override
  bool shouldRebuild(covariant _StickyHeaderDelegate oldDelegate) {
    return child != oldDelegate.child ||
        minHeight != oldDelegate.minHeight ||
        maxHeight != oldDelegate.maxHeight;
  }
}
