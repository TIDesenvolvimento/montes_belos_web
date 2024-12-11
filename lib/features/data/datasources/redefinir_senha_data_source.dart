import 'package:montesBelos/features/data/models/redefinir_senha_request.dart';

abstract class RedefinirSenhaDataSource {
  Future<bool> recuperarSenha(RedefinirSenhaRequest redefinirSenhaRequest);
  Future<bool> redefinirSenha(RedefinirSenhaRequest redefinirSenhaRequest);
}
