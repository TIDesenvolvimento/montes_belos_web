import 'package:dartz/dartz.dart';
import 'package:montesBelos/features/data/models/redefinir_senha_request.dart';

abstract class RedefinirSenhaRepository {
  Future<Either<Exception, bool>> recuperarSenha(
      RedefinirSenhaRequest redefinirSenhaRequest);
  Future<Either<Exception, bool>> redefinirSenha(
      RedefinirSenhaRequest redefinirSenhaRequest);
}
