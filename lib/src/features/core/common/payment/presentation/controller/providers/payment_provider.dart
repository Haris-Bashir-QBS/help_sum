import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:help_sum/src/core/dependency_injection/di_barrel.dart';
import 'package:help_sum/src/features/core/common/payment/presentation/controller/notifiers/payment_notifier.dart';
import 'package:help_sum/src/features/core/common/payment/presentation/controller/notifiers/payment_state.dart';

final paymentNotifierProvider =
    StateNotifierProvider<PaymentNotifier, PaymentState>(
      (ref) => PaymentNotifier(
        sl(), // AddCardUseCase
        sl(), // GetCardsUseCase
        sl(), // DeleteCardUseCase
        sl(), // SetDefaultCardUseCase
        sl(), // PayForJobUseCase
      ),
    );
