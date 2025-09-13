import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/core/dependency_injection/di_barrel.dart';
import 'package:help_sum/src/features/auth/data/models/request/update_profile_request_model.dart';
import 'package:help_sum/src/features/auth/data/models/request/upload_file_request_model.dart';
import 'package:help_sum/src/features/auth/domain/entities/user_entity.dart';
import 'package:help_sum/src/features/auth/domain/usecases/update_user_usecase.dart';
import 'package:help_sum/src/features/auth/domain/usecases/upload_file_usecase.dart';
import 'package:help_sum/src/features/auth/presentation/bloc/login/login_bloc.dart';

part 'portfolio_event.dart';
part 'portfolio_state.dart';

class PortfolioBloc extends Bloc<PortfolioEvent, PortfolioState> {
  late final UploadFileUseCase _uploadFileUseCase = sl();
  final UpdateUserProfileUsecase _updateUserProfileUsecase = sl();

  PortfolioBloc() : super(PortfolioState()) {
    on<UpdatePortfolioEvent>(_onUpdatePortfolio);

    on<UpdateUserEvent>((event, emit) async {
      emit(state.copyWith(userEntity: event.userEntity));
    });

    on<UpdateUserProfile>(_onUpdateUserProfile);
  }

  FutureOr<void> _onUpdateUserProfile(UpdateUserProfile event, emit) async {
    emit(state.copyWith(isLoading: true));

    final result = await _updateUserProfileUsecase(event.updateProfileRequest);
    await result.match(
      (failure) {
        emit(
          state.copyWith(isLoading: false, apiErrorMessage: failure.message),
        );
      },
      (user) async {
        final currentUser = user;
        sl<LoginBloc>().add(UpdateUser(userEntity: currentUser));
        emit(
          state.copyWith(
            isLoading: false,
            apiErrorMessage: '',
            profileUpdated: true,
          ),
        );
      },
    );
  }

  FutureOr<void> _onUpdatePortfolio(event, emit) async {
    emit(state.copyWith(fileUploaded: false, isLoading: true));

    log("Media Lentg${state.userEntity?.media?.length ?? 0}");

    final result = await _uploadFileUseCase(event.params);
    result.match(
      (failure) {
        emit(
          state.copyWith(
            apiErrorMessage: failure.message,
            fileUploaded: false,
            isLoading: false,
          ),
        );
      },
      (files) {
        final media = state.userEntity?.media ?? <String>[];
        log("updatedUrls $media");
        final urls = files.map((e) => e.url).toList();
        final currentUrls = state.userEntity?.media ?? <String>[];

        final List<String> updatedUrls = [...urls, ...currentUrls];

        log("updatedUrls $currentUrls");
        emit(
          state.copyWith(
            fileUploaded: true,
            isLoading: false,
            userEntity: state.userEntity?.copyWith(media: updatedUrls),
          ),
        );
        add(
          UpdateUserProfile(
            updateProfileRequest: UpdateProfileRequest(media: updatedUrls),
          ),
        );
      },
    );
  }
}
