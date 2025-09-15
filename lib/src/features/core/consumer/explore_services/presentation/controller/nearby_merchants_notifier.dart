import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/data/models/request/Booking_request_model.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/domain/usecases/get_nearby_merchants_usecase.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/controller/nearby_merchants_state.dart';

class NearbyMerchantsNotifier extends StateNotifier<NearbyMerchantsState> {
  final GetNearbyMerchantsUseCase _getNearbyMerchantsUseCase;

  int _currentPage = 1;
  final int _limit = 10;
  final List merchants = <dynamic>[];
  String? _lastServiceId;
  double? _lastLat;
  double? _lastLong;

  NearbyMerchantsNotifier(this._getNearbyMerchantsUseCase)
    : super(NearbyMerchantsInitial());

  Future<void> fetchNearbyMerchants({
    required double lat,
    required double long,
    String? serviceId,
    bool refresh = false,
  }) async {
    print("🔍 fetchNearbyMerchants called - lat: $lat, long: $long, serviceId: $serviceId, refresh: $refresh");
    final currentState = state;
    print("🔍 Current state: ${currentState.runtimeType}");
    
    // Check if parameters have changed (filter change)
    final hasParamsChanged = _lastLat != lat || _lastLong != long || _lastServiceId != serviceId;
    print("🔍 Parameters changed: $hasParamsChanged (lat: $_lastLat->$lat, long: $_lastLong->$long, serviceId: $_lastServiceId->$serviceId)");
    
    final isLoadedWithNoMore =
        currentState is NearbyMerchantsLoaded && !currentState.hasMore;

    if ((isLoadedWithNoMore && !refresh && !hasParamsChanged) ||
        (currentState is NearbyMerchantsLoading && !hasParamsChanged)) {
      print("🔍 Skipping - already loading or no more data, and no parameter change");
      return;
    }

    if (refresh || hasParamsChanged) {
      _currentPage = 1;
      merchants.clear();
      state = NearbyMerchantsLoading();
      print("🔍 Refreshing - cleared merchants, set loading state (refresh: $refresh, paramsChanged: $hasParamsChanged)");
    }

    final result = await _getNearbyMerchantsUseCase(
      BookingRequestModel(
        lat: lat,
        long: long,
        page: _currentPage,
        limit: _limit,
        serviceId: serviceId,
      ),
    );
    result.match(
      (failure) {
        print("❌ API Error: ${failure.message}");
        state = NearbyMerchantsError(failure.message);
      },
      (response) {
        print("✅ API Success - received ${response.data.data.length} merchants");
        print("🔍 Pagination: page ${response.data.pagination.page}, total: ${response.data.pagination.total}");
        merchants.addAll(response.data.data);
        final pagination = response.data.pagination;
        final hasMore = merchants.length < pagination.total;
        _currentPage = pagination.page + 1;
        state = NearbyMerchantsLoaded(
          merchants: List.from(merchants),
          hasMore: hasMore,
          totalCount: pagination.total,
        );
        print("✅ Final state: ${merchants.length} merchants loaded, hasMore: $hasMore");
        
        // Update last parameters
        _lastLat = lat;
        _lastLong = long;
        _lastServiceId = serviceId;
      },
    );
  }

  void loadMore({
    required double lat,
    required double long,
    String? serviceId,
  }) {
    fetchNearbyMerchants(lat: lat, long: long, serviceId: serviceId);
  }
}
