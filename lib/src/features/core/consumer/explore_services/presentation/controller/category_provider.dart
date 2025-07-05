import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:help_sum/src/core/dependency_injection/di_barrel.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/controller/category_notifier.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/controller/category_state.dart';

final categoryNotifierProvider =
    StateNotifierProvider<CategoryNotifier, CategoryState>(
      (ref) => CategoryNotifier(sl()),
    );
