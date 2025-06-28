import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/entities/user_entity.dart';

part 'user_notifier.g.dart';

@riverpod
class UserNotifier extends _$UserNotifier {
  @override
  UserEntity? build() => null;

  void setUser(UserEntity user) => state = user;

  void clearUser() => state = null;

  UserEntity? get currentUser => state;
}
