import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/features/core/common/profile/domain/repositories/profile_repository.dart';
import '../../../../../../core/use_cases/use_case.dart';

class DeleteAccountUseCase extends UseCase<void, NoParams> {
  final ProfileRepository _profileRepository;

  DeleteAccountUseCase({required ProfileRepository profileRepository})
    : _profileRepository = profileRepository;

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await _profileRepository.deleteAccount();
  }
}
