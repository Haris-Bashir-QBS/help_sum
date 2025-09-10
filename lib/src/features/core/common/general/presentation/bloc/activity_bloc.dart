import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'activity_event.dart';
part 'activity_state.dart';

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  ActivityBloc() : super(ActivityState()) {
    on<ActivityEvent>((event, emit) {});
    on<TabChanged>((event, emit) {
      emit(state.copyWith(selectedTab: event.index));
    });
  }
}
  