import 'package:help_sum/src/features/core/common/wallet/domain/entities/wallet.dart';
import 'package:help_sum/src/features/core/common/wallet/domain/repositories/wallet_repository.dart';

class GetWalletUseCase {
  final WalletRepository repository;
  GetWalletUseCase(this.repository);

  Future<WalletEntity> call() => repository.getWallet();
}


