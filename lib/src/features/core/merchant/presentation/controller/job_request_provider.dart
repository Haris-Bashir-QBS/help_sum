import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:help_sum/src/core/dependency_injection/di_barrel.dart';
import 'package:help_sum/src/features/core/merchant/presentation/controller/job_request_notifier.dart';
import 'package:help_sum/src/features/core/merchant/presentation/controller/job_request_states.dart';

final merchantJobsNotifierProvider =
    StateNotifierProvider<MerchantJobsNotifier, MerchantJobsState>(
      (ref) => MerchantJobsNotifier(sl()),
    );
