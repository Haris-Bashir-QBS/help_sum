import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:help_sum/src/core/constants/print_logs.dart';
import 'package:help_sum/src/features/core/common/wallet/domain/entities/wallet.dart';
import 'package:help_sum/src/features/core/common/wallet/domain/usecases/get_wallet_usecase.dart';

part 'wallet_event.dart';
part 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final GetWalletUseCase getWalletUseCase;
  WalletBloc({required this.getWalletUseCase}) : super(WalletInitial()) {
    on<LoadWallet>(_onLoadWallet);
  }

  Future<void> _onLoadWallet(
    LoadWallet event,
    Emitter<WalletState> emit,
  ) async {
    print("Logs #{wallet Loading}");
    emit(WalletLoading());
    try {
      final wallet = await getWalletUseCase.call();
      print("Logs ${wallet.recentPayments.jobId}");
      printLogs("wallet --1 ${wallet.recentPayments.jobId}");
      printLogs("wallet --1${wallet.recentPayments.status}");
      printLogs("wallet --1${wallet.recentPayments.title}");
      printLogs("wallet --1${wallet.recentPayments.at}");
      emit(WalletLoaded(wallet));
    } catch (e) {
      emit(WalletError(e.toString()));
    }
  }
}
