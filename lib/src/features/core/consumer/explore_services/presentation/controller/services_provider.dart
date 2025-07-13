import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:help_sum/src/core/dependency_injection/di_barrel.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/controller/services_notifier.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/controller/services_state.dart';

final servicesNotifierProvider =
    StateNotifierProvider<ServicesNotifier, ServicesState>((ref) {
      return ServicesNotifier(sl());
    });
