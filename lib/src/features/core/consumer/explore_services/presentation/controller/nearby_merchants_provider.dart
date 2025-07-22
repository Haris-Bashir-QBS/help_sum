import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:help_sum/src/core/dependency_injection/di_barrel.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/controller/nearby_merchants_notifier.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/controller/nearby_merchants_state.dart';

final nearbyMerchantsProvider =
    StateNotifierProvider<NearbyMerchantsNotifier, NearbyMerchantsState>(
      (ref) => NearbyMerchantsNotifier(sl()),
    );
