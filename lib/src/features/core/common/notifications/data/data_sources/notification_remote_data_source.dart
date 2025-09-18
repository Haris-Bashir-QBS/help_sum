import 'package:help_sum/src/features/core/common/notifications/data/models/notification_model.dart';

abstract interface class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications();
}
