import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:help_sum/src/core/dependency_injection/di_barrel.dart';
import 'package:help_sum/src/features/core/consumer/booking/data/models/job_response_model.dart';
import 'all_bookings_notifier.dart';

final allBookingsProvider = StateNotifierProvider.family
    .autoDispose<AllBookingsNotifier, AsyncValue<JobResponseModel>, String>(
      (ref, type) => AllBookingsNotifier(sl(), type),
    );
