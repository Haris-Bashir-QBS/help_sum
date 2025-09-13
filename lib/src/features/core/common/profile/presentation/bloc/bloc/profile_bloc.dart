import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:help_sum/src/features/core/common/profile/domain/entities/rating_entity.dart';
import 'package:help_sum/src/features/core/common/profile/domain/usecases/get_merchant_ratings_usecase.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileBlocEvent, ProfileBlocState> {
  final GetMerchantRatingsUseCase _getMerchantRatingsUseCase;

  ProfileBloc({required GetMerchantRatingsUseCase getMerchantRatingsUseCase})
      : _getMerchantRatingsUseCase = getMerchantRatingsUseCase,
        super(ProfileBlocState()) {
    on<ProfileBlocEvent>((event, emit) {});
    on<ProfileTabChanged>((event, emit) {
      emit(state.copyWith(selectedIndex: event.selectedIndex));
    });
    on<FetchMerchantRatings>((event, emit) async {
      emit(state.copyWith(isLoading: true, apiErrorMessage: ''));
      
      final result = await _getMerchantRatingsUseCase(
        GetMerchantRatingsParams(merchantId: event.merchantId),
      );
      
      result.fold(
        (failure) => emit(state.copyWith(
          isLoading: false,
          apiErrorMessage: failure.message,
        )),
        (ratingResponse) => emit(state.copyWith(
          isLoading: false,
          ratings: ratingResponse.data,
        )),
      );
    });
  }
}
