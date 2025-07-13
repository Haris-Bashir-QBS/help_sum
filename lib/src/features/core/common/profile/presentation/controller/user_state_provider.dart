import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:help_sum/src/features/auth/presentation/controller/notifiers/auth_state.dart';
import 'package:help_sum/src/features/core/common/profile/presentation/controller/user_state_notifier.dart';

final currentUserProvider = StateNotifierProvider<UserStateNotifier, UserState>(
  (ref) => UserStateNotifier(),
);
