import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:help_sum/src/core/network/client/dio_client.dart';
import 'package:help_sum/src/features/core/common/payment/data/datasources/remote/payment_remote_datasource.dart';
import 'package:help_sum/src/features/core/common/payment/data/datasources/remote/payment_remote_datasource_impl.dart';
import 'package:help_sum/src/features/core/common/payment/data/repositories/payment_repository_impl.dart';
import 'package:help_sum/src/features/core/common/payment/domain/repositories/payment_repository.dart';
import 'package:help_sum/src/features/core/common/payment/domain/usecases/rate_job_usecase.dart';
import 'package:help_sum/src/features/core/common/payment/presentation/controller/notifiers/rating_notifier.dart';
import 'package:help_sum/src/features/core/common/payment/presentation/controller/notifiers/rating_state.dart';

// DioClient Provider
final dioClientProvider = Provider<DioClient>(
  (ref) => DioClient(),
);

// DataSource Provider
final paymentRemoteDataSourceProvider = Provider<PaymentRemoteDataSource>(
  (ref) => PaymentRemoteDataSourceImplementation(
    client: ref.watch(dioClientProvider),
  ),
);

// Repository Provider
final paymentRepositoryProvider = Provider<PaymentRepository>(
  (ref) => PaymentRepositoryImplementation(
    remoteDataSource: ref.watch(paymentRemoteDataSourceProvider),
  ),
);

// UseCase Provider
final rateJobUseCaseProvider = Provider<RateJobUseCase>(
  (ref) => RateJobUseCase(
    repository: ref.watch(paymentRepositoryProvider),
  ),
);

// State Notifier Provider
final ratingNotifierProvider = StateNotifierProvider<RatingNotifier, RatingState>(
  (ref) => RatingNotifier(
    ref.watch(rateJobUseCaseProvider),
  ),
);