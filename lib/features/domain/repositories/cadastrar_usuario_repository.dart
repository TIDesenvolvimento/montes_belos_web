import 'package:dartz/dartz.dart';
import 'package:montesBelos/features/data/models/cadastrar_usuario_request.dart';
import 'package:montesBelos/features/domain/entities/novo_usuario_status.dart';

abstract class CadastrarUsuarioRepository {
  Future<Either<Exception, NovoUsuarioStatus>> cadastrarUsuario(
      NovoUsuarioRequest cadastrarUsuarioRequest);
}
