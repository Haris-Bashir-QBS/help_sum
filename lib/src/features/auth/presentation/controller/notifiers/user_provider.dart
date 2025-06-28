import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:help_sum/src/features/auth/domain/entities/user_entity.dart';
import 'package:help_sum/src/features/auth/presentation/controller/notifiers/user_notifier.dart';

final userProvider = NotifierProvider<UserNotifier, UserEntity?>(
  UserNotifier.new,
);
