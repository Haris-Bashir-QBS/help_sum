import 'package:help_sum/src/core/extensions/dio_extensions.dart';
import 'package:help_sum/src/core/network/client/dio_client.dart';
import 'package:help_sum/src/features/core/common/notifications/data/data_sources/notification_remote_data_source.dart';
import 'package:help_sum/src/features/core/common/notifications/data/models/notification_model.dart';

import '../../../../../../core/errors/api_exceptions.dart';
import '../../../../../../core/network/config/api_endpoints.dart';
import '../../../../../../core/network/config/error_handler.dart';

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final DioClient _client;

  NotificationRemoteDataSourceImpl(this._client);

  @override
  Future<List<NotificationModel>> getNotifications() async {
    return await ApiErrorHandler.executeGuarded(() async {
      final response = await _client.get(
        endpoint: ApiEndpoints.notifications.value,
      );

      if (response.isOk) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => NotificationModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          statusCode: response.statusCode,
          message: response.data['message'] ?? 'Failed to fetch notifications',
        );
      }
    });
  }
}
