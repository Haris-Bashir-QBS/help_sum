import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:help_sum/src/core/dependency_injection/di_barrel.dart';
import 'package:help_sum/src/features/auth/data/models/request/upload_file_request_model.dart';
import 'package:help_sum/src/features/auth/data/models/response/upload_file_response.dart';
import 'package:help_sum/src/features/auth/domain/usecases/upload_file_usecase.dart';
import 'package:help_sum/src/features/core/consumer/booking/data/models/job_request_model.dart';
import 'package:help_sum/src/features/core/consumer/booking/data/models/job_response_model.dart';
import 'package:help_sum/src/features/core/consumer/booking/domain/usecases/create_job_usecase.dart';

part 'create_job_event.dart';
part 'create_job_state.dart';

class CreateJobBloc extends Bloc<CreateJobEvent, CreateJobState> {
  final CreateJobUseCase _createJobUseCase = sl();
  final UploadFileUseCase uploadFileUseCase = sl();

  CreateJobBloc() : super(CreateJobInitial()) {
    on<CreateNewRequest>((event, emit) async {
      emit(CreateJobLoading());
      final result = await _createJobUseCase(event.jobRequestModel);
      result.match(
        (failure) => emit(CreateJobError(failure.message)),
        (response) => emit(CreateJobSuccess(response)),
      );
    });

    on<UploadNewFile>(_updateProfileImage);
  }

  FutureOr<void> _updateProfileImage(UploadNewFile event, emit) async {
    emit(UploadFileLoading());
    final result = await uploadFileUseCase(event.file);
    result.match(
      (failure) {
        emit(UploadFileError(message: failure.message));
      },
      (files) {
        emit(UploadFileSuccess(files: files));
      },
    );
  }
}
