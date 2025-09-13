import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:help_sum/src/features/core/common/profile/domain/entities/rating_entity.dart';
import 'package:help_sum/src/features/core/common/profile/domain/usecases/get_merchant_ratings_usecase.dart';
import 'package:help_sum/src/features/core/common/profile/domain/usecases/delete_account_usecase.dart';

import '../../../../../../../core/use_cases/use_case.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileBlocEvent, ProfileBlocState> {
  final GetMerchantRatingsUseCase _getMerchantRatingsUseCase;
  final DeleteAccountUseCase _deleteAccountUseCase;

  ProfileBloc({
    required GetMerchantRatingsUseCase getMerchantRatingsUseCase,
    required DeleteAccountUseCase deleteAccountUseCase,
  }) : _getMerchantRatingsUseCase = getMerchantRatingsUseCase,
       _deleteAccountUseCase = deleteAccountUseCase,
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
        (failure) => emit(
          state.copyWith(isLoading: false, apiErrorMessage: failure.message),
        ),
        (ratingResponse) => emit(
          state.copyWith(isLoading: false, ratings: ratingResponse.data),
        ),
      );
    });
    on<DeleteAccount>((event, emit) async {
      emit(state.copyWith(isDeletingAccount: true, apiErrorMessage: ''));

      final result = await _deleteAccountUseCase(NoParams());

      result.fold(
        (failure) => emit(
          state.copyWith(
            isDeletingAccount: false,
            apiErrorMessage: failure.message,
          ),
        ),
        (_) => emit(
          state.copyWith(isDeletingAccount: false, accountDeleted: true),
        ),
      );
    });
  }
}
