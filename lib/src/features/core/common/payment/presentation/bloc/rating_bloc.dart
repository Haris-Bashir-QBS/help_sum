import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:help_sum/src/core/dependency_injection/di_barrel.dart';
import 'package:help_sum/src/features/auth/data/models/request/upload_file_request_model.dart';
import 'package:help_sum/src/features/auth/domain/usecases/upload_file_usecase.dart';
import 'package:help_sum/src/features/core/common/payment/data/models/request/rate_job_request_model.dart';
import 'package:help_sum/src/features/core/common/payment/domain/usecases/rate_job_usecase.dart';
import 'package:help_sum/src/features/core/common/payment/presentation/bloc/rating_state.dart';

part 'rating_event.dart';

class RatingBloc extends Bloc<RatingEvent, RatingState> {
  final RateJobUseCase _rateJobUseCase = RateJobUseCase(repository: sl());
  final UploadFileUseCase _uploadFileUseCase = sl();
  RatingBloc() : super(RatingInitial()) {
    on<RatingEvent>((event, emit) {});
    on<PostRating>(rateJob);
    on<UploadImage>(uploadImage);
  }

  Future<void> rateJob(PostRating event, emit) async {
    emit(RatingLoading());
    final result = await _rateJobUseCase(event.rateJobRequestModel);

    result.match(
      (failure) => emit(RatingError(failure.message)),
      (response) => emit(RatingSuccess(response)),
    );
  }

  Future<void> uploadImage(UploadImage event, emit) async {
    emit(UploadImageLoading());
    final result = await _uploadFileUseCase(event.file);
    result.match(
      (failure) => emit(UploadImageError(failure.message)),
      (files) => emit(UploadImageSuccess(files)),
    );
  }
}
