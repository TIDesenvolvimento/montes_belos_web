import 'package:montesBelos/features/data/models/login_request.dart';
import 'package:montesBelos/features/data/models/login_response.dart';

abstract class LoginDataSource {
  Future<LoginResponse> realizarLogin(LoginRequest loginRequest);
}
