import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:montesBelos/features/data/models/redefinir_senha_request.dart';
import 'package:montesBelos/features/domain/usecases/redefinir_senha_use_case.dart';

class RedefinirSenhaStore extends NotifierStore<Exception, bool> {
  final RedefinirSenhaUseCase redefinirSenhaUseCase;

  RedefinirSenhaStore(this.redefinirSenhaUseCase) : super(false);

  recuperarSenha(RedefinirSenhaRequest redefinirSenhaRequest) async {
    setLoading(true);
    final result = await redefinirSenhaUseCase(redefinirSenhaRequest);
    result.fold((error) {
      setError(error);
      setLoading(false);
    }, (sucesso) {
      update(sucesso);
      setLoading(false);
    });
    setLoading(false);
  }

  redefinirSenha(
      String senhaAtual, String novaSenha, String novaSenhaConfirmada) async {
    setLoading(true);
    final result = await redefinirSenhaUseCase.redefinirSenha(
        getRedefinirSenhaRequest(senhaAtual, novaSenha, novaSenhaConfirmada));
    result.fold((error) {
      setError(error);
      setLoading(false);
    }, (sucesso) {
      update(sucesso);
      setLoading(false);
    });
    setLoading(false);
  }

  RedefinirSenhaRequest getRedefinirSenhaRequest(
      String senhaAtual, String novaSenha, String novaSenhaConfirmada) {
    var senhaAtualBytes = utf8.encode(senhaAtual);
    var novaSenhaBytes = utf8.encode(novaSenha);
    var novaSenhaConfirmadaBytes = utf8.encode(novaSenhaConfirmada);

    return RedefinirSenhaRequest(
        senhaAtual: sha1.convert(senhaAtualBytes).toString(),
        email: '',
        novaSenha: sha1.convert(novaSenhaBytes).toString(),
        novaSenhaConfirmada: sha1.convert(novaSenhaConfirmadaBytes).toString());
  }
}
