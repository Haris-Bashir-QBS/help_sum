import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:help_sum/src/features/core/consumer/booking/data/models/job_response_model.dart';
import 'package:help_sum/src/features/core/consumer/booking/domain/usecases/fetch_jobs_by_type_usecase.dart';

class AllBookingsNotifier extends StateNotifier<AsyncValue<JobResponseModel>> {
  final FetchJobsByTypeUseCase fetchJobsByTypeUseCase;
  final String type;

  // Pagination state
  int _currentPage = 1;
  final List<JobData> _allJobs = [];
  bool _hasMore = true;
  bool _isLoadingMore = false;

  AllBookingsNotifier(this.fetchJobsByTypeUseCase, this.type)
    : super(const AsyncLoading()) {
    fetchJobs();
  }

  Future<void> fetchJobs({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _allJobs.clear();
      _hasMore = true;
      if (mounted) {
        state = const AsyncLoading();
      }
    } else if (_isLoadingMore) {
      return; // Don't fetch if already loading more
    }

    try {
      final params = FetchJobsByTypeParams(
        type: type,
        page: _currentPage,
        limit: 10,
      );
      final result = await fetchJobsByTypeUseCase(params);
      
      if (!mounted) return; // Check if still mounted after async operation
      
      result.fold(
        (failure) => state = AsyncError(failure, StackTrace.current),
        (data) {
          if (refresh) {
            _allJobs.clear();
          }

          _allJobs.addAll(data.data.data);

          // Update pagination state
          final pagination = data.data.pagination;
          _hasMore = pagination.page < pagination.totalPages;
          _currentPage = pagination.page + 1;

          // Create a new response with accumulated jobs
          final updatedData = JobResponseModel(
            status: data.status,
            code: data.code,
            message: data.message,
            data: JobListData(
              data: List<JobData>.from(_allJobs),
              pagination: pagination,
            ),
          );

          if (mounted) {
            state = AsyncData(updatedData);
          }
        },
      );
    } catch (e, stackTrace) {
      if (mounted) {
        state = AsyncError(e, stackTrace);
      }
    }
  }

  Future<void> loadMore() async {
    if (!_hasMore || _isLoadingMore) return;

    _isLoadingMore = true;
    await fetchJobs();
    if (mounted) {
      _isLoadingMore = false;
    }
  }

  void refresh() {
    fetchJobs(refresh: true);
  }

  // Getters for pagination state
  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;
  int get currentPage => _currentPage;
  int get totalJobs => _allJobs.length;
}
