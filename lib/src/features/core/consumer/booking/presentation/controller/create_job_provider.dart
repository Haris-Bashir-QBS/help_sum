import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:help_sum/src/core/dependency_injection/di_barrel.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/controller/create_job_notifier.dart';

final createJobProvider =
    StateNotifierProvider<CreateJobNotifier, CreateJobState>(
      (ref) => CreateJobNotifier(sl()),
    );
