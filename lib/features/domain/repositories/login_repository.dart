import 'package:dartz/dartz.dart';
import 'package:montesBelos/features/data/models/login_request.dart';
import 'package:montesBelos/features/data/models/purchase_request.dart';

abstract class LoginRepository {
  Future<Either<Exception, ClienteWeb>> realizarLogin(
      LoginRequest loginRequest);
}
