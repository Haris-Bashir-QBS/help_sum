import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:help_sum/src/core/dependency_injection/di_barrel.dart';
import 'package:help_sum/src/core/services/local_storage_service.dart';
import 'package:help_sum/src/core/use_cases/use_case.dart';
import 'package:help_sum/src/features/auth/data/models/request/update_profile_request_model.dart';
import 'package:help_sum/src/features/auth/data/models/response/user_model.dart';
import 'package:help_sum/src/features/auth/domain/entities/grouped_category_entity.dart';
import 'package:help_sum/src/features/auth/domain/usecases/get_groupped_services_usecase.dart';
import 'package:help_sum/src/features/auth/domain/usecases/update_user_usecase.dart';
import 'package:help_sum/src/features/auth/presentation/bloc/login/login_bloc.dart';

part 'skill_event.dart';
part 'skill_state.dart';

class SkillBloc extends Bloc<SkillEvent, SkillState> {
  late final GetGroupedServicesUseCase _getGroupedServicesUseCase = sl();
  final UpdateUserProfileUsecase _updateUserProfileUsecase = sl();

  SkillBloc() : super(SkillState()) {
    on<SkillEvent>((event, emit) {});
    on<LoadSkills>((event, emit) async {
      emit(state.copyWith(isLoading: true, apiErrorMessage: ''));
      final result = await _getGroupedServicesUseCase(NoParams());

      result.match(
        (failure) {
          emit(
            state.copyWith(isLoading: false, apiErrorMessage: failure.message),
          );
        },
        (data) async {
          emit(
            state.copyWith(isLoading: false, apiErrorMessage: '', cats: data),
          );

          final userSelected = sl<LoginBloc>().state.userEntity?.services;
          if (userSelected != null && userSelected.isNotEmpty) {
            final matchedServices =
                data
                    .expand((group) => group.services)
                    .where(
                      (service) =>
                          userSelected.any((u) => u['_id'] == service.id),
                    )
                    .toList();

            emit(state.copyWith(selectedServices: matchedServices));
          }
        },
      );
    });
    on<UpdateSkill>((event, emit) async {
      emit(state.copyWith(savingSkills: true));
      final result = await _updateUserProfileUsecase(
        UpdateProfileRequest(services: event.selectedSkills),
      );
      await result.match(
        (failure) {
          emit(
            state.copyWith(
              savingSkills: false,
              apiErrorMessage: failure.message,
            ),
          );
        },
        (user) async {
          await LocalStorageService().saveUser(UserModel.fromEntity(user));
          sl<LoginBloc>().add(UpdateUser(userEntity: user));
          emit(
            state.copyWith(
              savingSkills: false,
              apiErrorMessage: '',
              skillUpdated: true,
            ),
          );
        },
      );
    });

    on<SearchSkill>((event, emit) {
      if (event.searchText.isEmpty) {
        emit(state.copyWith(isSearching: false, filteredServices: []));
      } else {
        final filteredServices =
            state.cats.map((category) {
              final filteredServices =
                  category.services.where((service) {
                    return service.name.toLowerCase().contains(
                      event.searchText.toLowerCase(),
                    );
                  }).toList();
              return GroupedCategoryEntity(
                id: category.id,
                categoryName: category.categoryName,
                services: filteredServices,
              );
            }).toList();

        emit(
          state.copyWith(isSearching: true, filteredServices: filteredServices),
        );
      }
    });

    on<AddSkill>((event, emit) {
      final updatedSelectedServices = List<ServiceEntity>.from(
        state.selectedServices,
      );
      if (!updatedSelectedServices.any(
        (service) => service.id == event.skill.id,
      )) {
        updatedSelectedServices.add(event.skill);
        emit(state.copyWith(selectedServices: updatedSelectedServices));
      } else {
        //Remove skill if already selected
        updatedSelectedServices.removeWhere(
          (service) => service.id == event.skill.id,
        );
        emit(state.copyWith(selectedServices: updatedSelectedServices));
      }
    });

    on<RemoveSkill>((event, emit) {
      final updatedSelectedServices = List<ServiceEntity>.from(
        state.selectedServices,
      );
      updatedSelectedServices.removeWhere(
        (service) => service.id == event.skill.id,
      );
      emit(state.copyWith(selectedServices: updatedSelectedServices));
    });
  }
}
