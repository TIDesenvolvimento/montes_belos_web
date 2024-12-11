import 'package:dartz/dartz.dart';
import 'package:montesBelos/core/utils/constants/constants.dart';
import 'package:montesBelos/core/utils/constants/strings.dart';
import 'package:montesBelos/features/data/datasources/cadastrar_usuario_data_source.dart';
import 'package:montesBelos/features/data/models/cadastrar_usuario_request.dart';
import 'package:montesBelos/features/domain/entities/novo_usuario_status.dart';
import 'package:montesBelos/features/domain/entities/viagem.dart';
import 'package:montesBelos/features/domain/repositories/cadastrar_usuario_repository.dart';

class CadastrarUsuarioRepositoryImplementacao
    extends CadastrarUsuarioRepository {
  CadastrarUsuarioDataSource cadastrarUsuarioDataSource;
  List<Viagem> viagens = [];

  CadastrarUsuarioRepositoryImplementacao(this.cadastrarUsuarioDataSource);

  @override
  Future<Either<Exception, NovoUsuarioStatus>> cadastrarUsuario(
      NovoUsuarioRequest cadastrarUsuarioRequest) async {
    try {
      final result = await cadastrarUsuarioDataSource
          .cadastrarUsuario(cadastrarUsuarioRequest);
      if (result.sucesso == Constants.STATUS_SUCESS) {
        return Right(NovoUsuarioStatus(
            mensagem: result.mensagem, usuarioCadastrado: true));
      }
      return Left(Exception(result.mensagem));
    } on Exception {
      return Left(Exception(falha_interna_no_servidor));
    }
  }
}
