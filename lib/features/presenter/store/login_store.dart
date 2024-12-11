import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:montesBelos/features/data/models/login_request.dart';
import 'package:montesBelos/features/data/models/purchase_request.dart';
import 'package:montesBelos/features/domain/usecases/login_use_case.dart';

class LoginStore extends NotifierStore<Exception, ClienteWeb> {
  final LoginUseCase loginUseCase;

  LoginStore(this.loginUseCase) : super(ClienteWeb());

  realizarLogin(LoginRequest loginRequest) async {
    setLoading(true);
    final result = await loginUseCase(getLoginRequest(loginRequest));
    result.fold((error) {
      setLoading(false);
      setError(error);
    }, (sucesso) {
      update(sucesso);
      setLoading(false);
    });
    setLoading(false);
  }

  getLoginRequest(LoginRequest loginRequest) {
    var senhaBytes = utf8.encode(loginRequest.senha!);
    return LoginRequest(
      email: loginRequest.email,
      idDaConta: loginRequest.idDaConta,
      tipoDaConta: loginRequest.tipoDaConta,
      senha:
          loginRequest.senha == '' ? '' : sha1.convert(senhaBytes).toString(),
    );
  }
}
