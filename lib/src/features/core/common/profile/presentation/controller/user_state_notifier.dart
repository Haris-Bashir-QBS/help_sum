import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:help_sum/src/features/auth/domain/entities/user_entity.dart';
import 'package:help_sum/src/features/auth/presentation/controller/notifiers/auth_state.dart';

class UserStateNotifier extends StateNotifier<UserState> {
  UserStateNotifier() : super(const UserState());

  void setUser(UserEntity user) {
    state = state.copyWith(user: user);
  }

  void clearUser() {
    state = const UserState(user: null);
  }

  void updateUser(UserEntity user) {
    state = state.copyWith(user: user);
  }
}
