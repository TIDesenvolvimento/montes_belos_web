import 'package:dartz/dartz.dart';
import 'package:montesBelos/core/usecase/use_case.dart';
import 'package:montesBelos/features/data/models/login_request.dart';
import 'package:montesBelos/features/data/models/purchase_request.dart';
import 'package:montesBelos/features/domain/repositories/login_repository.dart';

class LoginUseCase implements UseCase<ClienteWeb, LoginRequest> {
  LoginRepository loginRepository;

  LoginUseCase(this.loginRepository);

  @override
  Future<Either<Exception, ClienteWeb>> call(LoginRequest loginRequest) async {
    return await loginRepository.realizarLogin(loginRequest);
  }
}
