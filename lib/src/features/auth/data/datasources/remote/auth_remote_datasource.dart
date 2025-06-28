import 'package:help_sum/src/features/auth/data/models/request/login_request_model.dart';
import 'package:help_sum/src/features/auth/data/models/request/signup_request_model.dart';

import '../../models/response/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel> login({required LoginRequestModel params});
  Future<String> signup({required SignUpRequestModel params});
}
