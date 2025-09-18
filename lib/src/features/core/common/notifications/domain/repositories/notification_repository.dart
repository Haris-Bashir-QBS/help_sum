import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/features/core/common/notifications/data/models/notification_model.dart';

abstract interface class NotificationRepository {
  Future<Either<Failure, List<NotificationModel>>> getNotifications();
}
