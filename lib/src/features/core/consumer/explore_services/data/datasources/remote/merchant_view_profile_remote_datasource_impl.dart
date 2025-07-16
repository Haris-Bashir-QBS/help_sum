import 'package:help_sum/src/core/network/client/dio_client.dart';
import 'merchant_view_profile_remote_datasource.dart';

class MerchantViewProfileRemoteDatasourceImpl
    implements MerchantViewProfileRemoteDatasource {
  final DioClient client;
  MerchantViewProfileRemoteDatasourceImpl(this.client);

  @override
  Future<Map<String, dynamic>> fetchMerchantProfile(String merchantId) async {
    final response = await client.get(endpoint: '/user/profile/$merchantId');
    return response.data['data'] as Map<String, dynamic>;
  }
}
