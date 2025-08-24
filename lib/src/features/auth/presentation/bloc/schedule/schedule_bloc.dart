import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:help_sum/src/core/dependency_injection/di_barrel.dart';
import 'package:help_sum/src/core/services/local_storage_service.dart';
import 'package:help_sum/src/features/auth/data/models/request/update_profile_request_model.dart';
import 'package:help_sum/src/features/auth/data/models/response/user_model.dart';
import 'package:help_sum/src/features/auth/domain/usecases/update_user_usecase.dart';
import 'package:help_sum/src/features/auth/presentation/bloc/login/login_bloc.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final UpdateUserProfileUsecase _updateUserProfileUsecase = sl();
  ScheduleBloc() : super(ScheduleState()) {
    on<UpdateUserSchedule>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      final result = await _updateUserProfileUsecase(event.schedule);
      await result.match(
        (failure) {
          emit(
            state.copyWith(isLoading: false, apiErrorMessage: failure.message),
          );
        },
        (user) async {
          final currentUser = user;
          currentUser.isCompleted = true;
          await LocalStorageService().saveUser(UserModel.fromEntity(user));
          sl<LoginBloc>().add(UpdateUser(userEntity: currentUser));
          emit(
            state.copyWith(
              isLoading: false,
              apiErrorMessage: '',
              scheduleCreated: true,
            ),
          );
        },
      );
    });
  }
}
