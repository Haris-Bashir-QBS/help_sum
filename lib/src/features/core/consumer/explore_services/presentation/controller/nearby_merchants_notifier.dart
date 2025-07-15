import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/data/models/request/Booking_request_model.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/domain/usecases/get_nearby_merchants_usecase.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/controller/nearby_merchants_state.dart';

class NearbyMerchantsNotifier extends StateNotifier<NearbyMerchantsState> {
  final GetNearbyMerchantsUseCase _getNearbyMerchantsUseCase;

  int _currentPage = 1;
  final int _limit = 10;
  final List merchants = <dynamic>[];

  NearbyMerchantsNotifier(this._getNearbyMerchantsUseCase)
    : super(NearbyMerchantsInitial());

  Future<void> fetchNearbyMerchants({
    required double lat,
    required double long,
    String? serviceId,
    bool refresh = false,
  }) async {
    final currentState = state;
    final isLoadedWithNoMore =
        currentState is NearbyMerchantsLoaded && !currentState.hasMore;

    if ((isLoadedWithNoMore && !refresh) ||
        currentState is NearbyMerchantsLoading) {
      print("Already loading or no more data to load");
      return;
    }

    if (refresh) {
      _currentPage = 1;
      merchants.clear();
      state = NearbyMerchantsLoading();
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
        state = NearbyMerchantsError(failure.message);
      },
      (response) {
        merchants.addAll(response.data.data);
        final pagination = response.data.pagination;
        final hasMore = merchants.length < pagination.total;
        _currentPage = pagination.page + 1;
        state = NearbyMerchantsLoaded(
          merchants: List.from(merchants),
          hasMore: hasMore,
          totalCount: pagination.total,
        );
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
