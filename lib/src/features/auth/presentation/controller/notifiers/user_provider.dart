import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:help_sum/src/features/auth/presentation/controller/notifiers/auth_state.dart';
import 'package:help_sum/src/features/auth/presentation/controller/notifiers/user_notifier.dart';

final currentUserProvider = StateNotifierProvider<UserStateNotifier, UserState>(
  (ref) => UserStateNotifier(),
);
