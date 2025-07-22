import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:help_sum/src/core/dependency_injection/di_barrel.dart';

import 'merchant_view_profile_notifier.dart';
import 'merchant_view_profile_state.dart';

final merchantViewProfileProvider = StateNotifierProvider.family<
  MerchantViewProfileNotifier,
  MerchantViewProfileState,
  String
>((ref, merchantId) {
  return MerchantViewProfileNotifier(sl());
});
