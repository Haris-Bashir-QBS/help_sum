import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/features/auth/data/models/request/upload_file_request_model.dart';
import 'package:help_sum/src/features/auth/data/models/response/upload_file_response.dart';
import 'package:help_sum/src/features/auth/domain/repositories/auth_repository.dart';

import '../../../../core/use_cases/use_case.dart';

class UploadFileUseCase
    extends UseCase<List<UploadedFileEntity>, UploadFileRequest> {
  final AuthRepository authRepository;
  UploadFileUseCase(this.authRepository);
  @override
  Future<Either<Failure, List<UploadedFileEntity>>> call(params) async {
    return await authRepository.uploadFile(params: params);
  }
}
