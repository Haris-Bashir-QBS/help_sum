import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:help_sum/src/features/core/common/payment/data/models/request/rate_job_request_model.dart';
import 'package:help_sum/src/features/core/common/payment/domain/usecases/rate_job_usecase.dart';
import 'rating_state.dart';

class RatingNotifier extends StateNotifier<RatingState> {
  final RateJobUseCase _rateJobUseCase;

  RatingNotifier(this._rateJobUseCase) : super(RatingInitial());

  Future<void> rateJob(RateJobRequestModel params) async {
    state = RatingLoading();
    final result = await _rateJobUseCase(params);

    result.match(
      (failure) => state = RatingError(failure.message),
      (response) => state = RatingSuccess(response),
    );
  }
}