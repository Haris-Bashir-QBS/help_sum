import 'payment.dart';

class WalletEntity {
  final double availableBalance;
  final Payment recentPayments;

  WalletEntity({required this.availableBalance, required this.recentPayments});
}
