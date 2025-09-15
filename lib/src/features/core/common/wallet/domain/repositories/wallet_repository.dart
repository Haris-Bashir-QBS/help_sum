import 'package:help_sum/src/features/core/common/wallet/domain/entities/wallet.dart';

abstract class WalletRepository {
  Future<WalletEntity> getWallet();
}


