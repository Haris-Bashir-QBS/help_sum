import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/core/use_cases/use_case.dart';
import 'package:help_sum/src/features/core/common/notifications/domain/entities/notification_entity.dart';
import 'package:help_sum/src/features/core/common/notifications/domain/usecases/notification_usecase.dart';

import '../../../../../../core/errors/api_exceptions.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final GetNotificationsUseCase _getNotificationsUseCase;

  NotificationCubit(this._getNotificationsUseCase)
    : super(NotificationInitial());

  Future<void> fetchNotifications() async {
    if (isClosed) return; // Check if cubit is closed before emitting
    
    emit(NotificationLoading());

    final Either<Failure, List<NotificationEntity>> result =
        await _getNotificationsUseCase(NoParams());

    if (isClosed) return; // Check again after async operation

    result.fold(
      (failure) => emit(NotificationError(failure.message)),
      (notifications) => emit(NotificationLoaded(notifications)),
    );
  }
}
