import 'package:dartz/dartz.dart';
import 'package:montesBelos/core/utils/constants/strings.dart';
import 'package:montesBelos/features/data/datasources/redefinir_senha_data_source.dart';
import 'package:montesBelos/features/data/models/redefinir_senha_request.dart';
import 'package:montesBelos/features/domain/entities/viagem.dart';
import 'package:montesBelos/features/domain/repositories/redefinir_senha_repository.dart';

class RedefinirSenhaRepositoryImplementacao extends RedefinirSenhaRepository {
  RedefinirSenhaDataSource redefinirSenhaDataSource;
  List<Viagem> viagens = [];

  RedefinirSenhaRepositoryImplementacao(this.redefinirSenhaDataSource);

  @override
  Future<Either<Exception, bool>> recuperarSenha(
      RedefinirSenhaRequest redefinirSenhaRequest) async {
    try {
      final result =
          await redefinirSenhaDataSource.recuperarSenha(redefinirSenhaRequest);
      if (result) {
        return Right(result);
      }
      return Left(Exception(redefinir_senha__texto_erro_ao_redefinir_senha));
    } on Exception {
      return Left(Exception(falha_interna_no_servidor));
    }
  }

  @override
  Future<Either<Exception, bool>> redefinirSenha(
      RedefinirSenhaRequest redefinirSenhaRequest) async {
    try {
      final result =
          await redefinirSenhaDataSource.redefinirSenha(redefinirSenhaRequest);
      if (result) {
        return Right(result);
      }
      return Left(Exception(redefinir_senha__texto_erro_ao_redefinir_senha));
    } on Exception {
      return Left(Exception(falha_interna_no_servidor));
    }
  }
}
