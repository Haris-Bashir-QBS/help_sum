import 'package:help_sum/src/core/network/client/dio_client.dart';

abstract class MerchantViewProfileRemoteDatasource {
  Future<Map<String, dynamic>> fetchMerchantProfile(String merchantId);
}
