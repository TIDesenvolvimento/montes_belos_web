import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:montesBelos/core/utils/builder/auth_interceptor.dart';
import 'package:montesBelos/core/utils/constants/constants.dart';
import 'package:montesBelos/features/data/datasources/cadastrar_usuario_data_source.dart';
import 'package:montesBelos/features/data/datasources/endpoints/endpoints.dart';
import 'package:montesBelos/features/data/models/cadastrar_usuario_request.dart';
import 'package:montesBelos/features/data/models/cadastrar_usuario_response.dart';

class CadastrarUsuarioDataSourceImplementacao
    extends CadastrarUsuarioDataSource {
  final http.Client client;

  CadastrarUsuarioDataSourceImplementacao({required this.client});

  @override
  Future<NovoUsuarioResponse> cadastrarUsuario(
      NovoUsuarioRequest cadastrarUsuarioRequest) async {
    final response = await client.post(Endpoints.cadastrarUsuario(),
        headers: AuthInterceptor().getHeadersClienteWeb(),
        body: jsonEncode(cadastrarUsuarioRequest.toJson()));
    if (response.statusCode == Constants.STATUS_CODE_200) {
      return NovoUsuarioResponse.fromJson(json.decode(response.body));
    }

    throw new Exception();
  }
}
