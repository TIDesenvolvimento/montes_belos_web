import 'package:montesBelos/features/data/models/cadastrar_usuario_request.dart';
import 'package:montesBelos/features/data/models/cadastrar_usuario_response.dart';

abstract class CadastrarUsuarioDataSource {
  Future<NovoUsuarioResponse> cadastrarUsuario(
      NovoUsuarioRequest cadastrarUsuarioRequest);
}
