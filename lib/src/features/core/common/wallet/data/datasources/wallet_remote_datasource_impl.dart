import 'package:help_sum/src/core/network/client/dio_client.dart';

import 'wallet_remote_datasource.dart';

class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  final DioClient _client;
  WalletRemoteDataSourceImpl(this._client);

  @override
  Future<Map<String, dynamic>> fetchWallet() async {
    final res = await _client.get(endpoint: '/user/wallet');
    return res.data as Map<String, dynamic>;
  }
}
