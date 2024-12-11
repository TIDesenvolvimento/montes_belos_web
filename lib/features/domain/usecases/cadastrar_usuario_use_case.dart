import 'package:dartz/dartz.dart';
import 'package:montesBelos/core/usecase/use_case.dart';
import 'package:montesBelos/features/data/models/cadastrar_usuario_request.dart';
import 'package:montesBelos/features/domain/entities/novo_usuario_status.dart';
import 'package:montesBelos/features/domain/repositories/cadastrar_usuario_repository.dart';

class CadastrarUsuarioUseCase
    implements UseCase<NovoUsuarioStatus, NovoUsuarioRequest> {
  CadastrarUsuarioRepository cadastrarUsuarioRepository;

  CadastrarUsuarioUseCase(this.cadastrarUsuarioRepository);

  @override
  Future<Either<Exception, NovoUsuarioStatus>> call(
      NovoUsuarioRequest cadastrarUsuarioRequest) async {
    return await cadastrarUsuarioRepository
        .cadastrarUsuario(cadastrarUsuarioRequest);
  }
}
