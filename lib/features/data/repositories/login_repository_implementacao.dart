import 'package:dartz/dartz.dart';
import 'package:montesBelos/core/utils/constants/constants.dart';
import 'package:montesBelos/core/utils/constants/strings.dart';
import 'package:montesBelos/features/data/datasources/login_data_source.dart';
import 'package:montesBelos/features/data/models/login_request.dart';
import 'package:montesBelos/features/data/models/purchase_request.dart';
import 'package:montesBelos/features/domain/repositories/login_repository.dart';

class LoginRepositoryImplementacao extends LoginRepository {
  LoginDataSource loginDataSource;

  LoginRepositoryImplementacao(this.loginDataSource);

  @override
  Future<Either<Exception, ClienteWeb>> realizarLogin(
      LoginRequest loginRequest) async {
    try {
      final result = await loginDataSource.realizarLogin(loginRequest);
      if (result.success == Constants.STATUS_SUCESS &&
          result.data != Constants.NULL) {
        var clienteWeb = result.data!.clienteWeb;
        clienteWeb!.tokenClienteWeb = result.data!.token;
        return Right(clienteWeb);
      }

      return Left(Exception(result.mensagem));
    } on Exception {
      return Left(Exception(falha_interna_no_servidor));
    }
  }
}
