import 'package:dartz/dartz.dart';
import 'package:montesBelos/core/usecase/use_case.dart';
import 'package:montesBelos/features/data/models/redefinir_senha_request.dart';
import 'package:montesBelos/features/domain/repositories/redefinir_senha_repository.dart';

class RedefinirSenhaUseCase implements UseCase<bool, RedefinirSenhaRequest> {
  RedefinirSenhaRepository redefinirSenhaRepository;

  RedefinirSenhaUseCase(this.redefinirSenhaRepository);

  @override
  Future<Either<Exception, bool>> call(
      RedefinirSenhaRequest redefinirSenhaRequest) async {
    return await redefinirSenhaRepository.recuperarSenha(redefinirSenhaRequest);
  }

  Future<Either<Exception, bool>> redefinirSenha(
      RedefinirSenhaRequest redefinirSenhaRequest) async {
    return await redefinirSenhaRepository.redefinirSenha(redefinirSenhaRequest);
  }
}
