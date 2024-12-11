import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:montesBelos/features/data/models/cadastrar_usuario_request.dart';
import 'package:montesBelos/features/domain/entities/novo_usuario_status.dart';
import 'package:montesBelos/features/domain/usecases/cadastrar_usuario_use_case.dart';

class NovoUsuarioStore extends NotifierStore<Exception, NovoUsuarioStatus> {
  final CadastrarUsuarioUseCase cadastrarUsuarioUseCase;

  NovoUsuarioStore(this.cadastrarUsuarioUseCase)
      : super(NovoUsuarioStatus(mensagem: '', usuarioCadastrado: false));

  cadastrarNovoUsuario(NovoUsuarioRequest novoUsuarioRequest) async {
    setLoading(true);

    final result = await cadastrarUsuarioUseCase(
        getNovoUsuarioRequest(novoUsuarioRequest));
    result.fold((error) {
      setError(error);
      setLoading(false);
    }, (sucesso) {
      update(sucesso);
      setLoading(false);
    });
    setLoading(true);
  }

  getNovoUsuarioRequest(NovoUsuarioRequest novoUsuarioRequest) {
    var senhaBytes = utf8.encode(novoUsuarioRequest.senha!);
    return NovoUsuarioRequest(
        email: novoUsuarioRequest.email,
        idDaConta: novoUsuarioRequest.idDaConta,
        nome: novoUsuarioRequest.nome,
        senha: sha1.convert(senhaBytes).toString(),
        tipoDaConta: novoUsuarioRequest.tipoDaConta);
  }
}
