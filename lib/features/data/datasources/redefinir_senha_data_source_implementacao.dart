import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:montesBelos/core/utils/builder/auth_interceptor.dart';
import 'package:montesBelos/core/utils/constants/constants.dart';
import 'package:montesBelos/features/data/datasources/endpoints/endpoints.dart';
import 'package:montesBelos/features/data/datasources/redefinir_senha_data_source.dart';
import 'package:montesBelos/features/data/models/redefinir_senha_request.dart';

class RedefinirSenhaDataSourceImplementacao extends RedefinirSenhaDataSource {
  final http.Client client;

  RedefinirSenhaDataSourceImplementacao({required this.client});

  @override
  Future<bool> recuperarSenha(
      RedefinirSenhaRequest redefinirSenhaRequest) async {
    final response = await client.post(Endpoints.recuperarSenha(),
        headers: AuthInterceptor().getHeadersClienteWeb(),
        body: jsonEncode(redefinirSenhaRequest.toJson()));
    if (response.statusCode == Constants.STATUS_CODE_200) {
      return true;
    }
    if (response.statusCode == Constants.STATUS_CODE_500) {
      return false;
    }
    throw new Exception();
  }

  @override
  Future<bool> redefinirSenha(
      RedefinirSenhaRequest redefinirSenhaRequest) async {
    final response = await client.post(Endpoints.redefinirSenha(),
        headers: AuthInterceptor().getHeaders(),
        body: jsonEncode(redefinirSenhaRequest.toJson()));
    if (response.statusCode == Constants.STATUS_CODE_200) {
      return true;
    }
    if (response.statusCode == Constants.STATUS_CODE_500) {
      return false;
    }
    throw new Exception();
  }
}
