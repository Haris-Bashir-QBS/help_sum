part of 'schedule_bloc.dart';

class ScheduleState extends Equatable {
  final bool isLoading;
  final String apiErrorMessage;
  final bool scheduleCreated;

  const ScheduleState({
    this.isLoading = false,
    this.apiErrorMessage = '',
    this.scheduleCreated = false,
  });

  @override
  List<Object> get props => [isLoading, apiErrorMessage, scheduleCreated];

  ScheduleState copyWith({
    bool? isLoading,
    String? apiErrorMessage,
    bool? scheduleCreated,
  }) {
    return ScheduleState(
      isLoading: isLoading ?? this.isLoading,
      apiErrorMessage: apiErrorMessage ?? '',
      scheduleCreated: scheduleCreated ?? this.scheduleCreated,
    );
  }
}
