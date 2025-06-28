import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/user_entity.dart';

class UserNotifier extends Notifier<UserEntity?> {
  @override
  UserEntity? build() => null;

  void setUser(UserEntity user) => state = user;

  void clearUser() => state = null;

  UserEntity? get currentUser => state;
}
