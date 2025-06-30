import 'package:get_it/get_it.dart';
import 'package:help_sum/src/core/services/local_storage_service.dart';
import 'package:help_sum/src/features/auth/domain/usecases/login_usecase.dart';
import 'package:help_sum/src/features/auth/domain/usecases/otp_use_case.dart';

import '../../features/auth/data/datasources/remote/auth_remote_datasource.dart';
import '../../features/auth/data/datasources/remote/auth_remote_datasource_impl.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/signup_usecase.dart';
import '../network/client/dio_client.dart';

part 'di_container.dart';
