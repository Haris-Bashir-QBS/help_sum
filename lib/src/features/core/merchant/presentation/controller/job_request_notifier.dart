import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:help_sum/src/features/core/consumer/booking/data/models/job_response_model.dart';
import 'package:help_sum/src/features/core/merchant/domain/params/merchant_by_type_param.dart';
import 'package:help_sum/src/features/core/merchant/domain/params/update_job_params.dart';
import 'package:help_sum/src/features/core/merchant/domain/usecases/complete_job_usecase.dart';
import 'package:help_sum/src/features/core/merchant/domain/usecases/fetch_jobs_by_type_merchant.dart';
import 'package:help_sum/src/features/core/merchant/domain/usecases/start_job_usecase.dart';
import 'package:help_sum/src/features/core/merchant/domain/usecases/update_job_status_merchant.dart';
import 'package:help_sum/src/features/core/merchant/presentation/controller/job_request_states.dart';
import 'package:help_sum/src/widgets/custom_toast.dart';

class MerchantJobsNotifier extends StateNotifier<MerchantJobsState> {
  final GetAllJobsByTypeUseCase _getServicesByCategoryUseCase;
  final UpdateJobStatusMerchantUseCase _merchantUseCase;
  final StartJobUseCase _startJobUseCase;
  final CompleteJobUseCase _completeJobUseCase;

  MerchantJobsNotifier(
    this._getServicesByCategoryUseCase,
    this._merchantUseCase,
    this._startJobUseCase,
    this._completeJobUseCase,
  ) : super(MerchantJobsInitial());

  int _currentPage = 1;
  List<JobData> allJobs = [];

  /// Update startJob method
  Future<void> startJob({required String jobId}) async {
    state = JobActionLoading('start');
    final result = await _startJobUseCase(jobId);

    result.match(
      (failure) {
        state = JobActionError('start', failure.message);
      },
      (response) {
        log('Job started: ${response.toString()}');
        state = JobActionSuccess('start', response);
      },
    );
  }

  /// Update completeJob method
  Future<void> completeJob({required String jobId}) async {
    state = JobActionLoading('complete');
    final result = await _completeJobUseCase(jobId);

    result.match(
      (failure) {
        state = JobActionError('complete', failure.message);
      },
      (response) {
        log('Job completed: ${response.toString()}');
        state = JobActionSuccess('complete', response);
      },
    );
  }

  // Update changeJobStatus method
  Future<void> changeJobStatus({
    final String? jobId,
    String? action,
    double? newHours,
    double? newOffer,
  }) async {
    state = JobActionLoading(action ?? 'update');

    final result = await _merchantUseCase(
      UpdateJobParams(
        jobId: jobId,
        action: action,
        newHours: newHours,
        newOffer: newHours,
      ),
    );

    result.match(
      (failure) {
        state = JobActionError(action ?? 'update', failure.message);
      },
      (response) {
        log(response.toString());
        state = JobActionSuccess(action ?? 'update', response);
      },
    );
  }

  Future<void> getAllJobsByType({
    // required String categoryId,
    required String jobType,
    bool refresh = false,
    int? page,
    int? limit,
  }) async {
    print("JJJ $state");
    final currentState = state;

    print(currentState is MerchantJobsLoading);

    if (currentState is MerchantJobsLoading) return;

    if (refresh) {
      _currentPage = 1;
      allJobs.clear();
      state = MerchantJobsLoading();
    }

    // Don't fetch if no more data
    final isLoadedWithNoMore =
        currentState is MerchantJobsLoaded && !currentState.hasMore;

    if (isLoadedWithNoMore && !refresh) {
      return;
    }

    final params = MerchantByTypeParam(
      jobType,
      // categoryId: categoryId,
      // page: page ?? _currentPage,
      // limit: limit ?? 10,
    );

    final result = await _getServicesByCategoryUseCase(params);

    result.match(
      (failure) {
        state = MerchantJobsError(failure.message);
      },
      (response) {
        allJobs.addAll(response.data.data ?? []);
        final pagination = response.data.pagination;
        final hasMore = (pagination.page ?? 0) < (pagination.totalPages ?? 0);
        _currentPage = (pagination.page ?? 0) + 1;

        state = MerchantJobsLoaded(
          response: response,
          hasMore: hasMore,
          totalCount: pagination.total ?? 0,
        );
      },
    );
  }

  void reset() {
    state = MerchantJobsInitial();
    _currentPage = 1;
    allJobs.clear();
  }
}
