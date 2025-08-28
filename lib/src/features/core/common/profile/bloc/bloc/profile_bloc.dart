import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileBlocEvent, ProfileBlocState> {
  ProfileBloc() : super(ProfileBlocState()) {
    on<ProfileBlocEvent>((event, emit) {});
    on<ProfileTabChanged>((event, emit) {
      emit(state.copyWith(selectedIndex: event.selectedIndex));
    });
  }
}
