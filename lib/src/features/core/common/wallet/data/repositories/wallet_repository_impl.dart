import 'package:help_sum/src/features/core/common/wallet/domain/entities/payment.dart';
import 'package:help_sum/src/features/core/common/wallet/domain/entities/wallet.dart';
import '../../../../../core/common/wallet/data/datasources/wallet_remote_datasource.dart';

class WalletRepositoryImpl {
  final WalletRemoteDataSource remote;
  WalletRepositoryImpl(this.remote);

  Future<WalletEntity> getWallet() async {
    final map = await remote.fetchWallet();
    print("MAAP ${map}");

    final double balance = (map['data']['wallet'] as num).toDouble();
    final paymentsJson = Payment.fromJson(map['data']['lastPayment']);

    return WalletEntity(
      availableBalance: balance,
      recentPayments: paymentsJson,
    );
  }
}
