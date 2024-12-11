import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:montesBelos/core/utils/builder/auth_interceptor.dart';
import 'package:montesBelos/core/utils/constants/constants.dart';
import 'package:montesBelos/features/data/datasources/atualizar_cliente_data_sorce.dart';
import 'package:montesBelos/features/data/datasources/endpoints/endpoints.dart';
import 'package:montesBelos/features/data/models/atualizar_cliente_request.dart';

class AtualizarclienteDataSourceImplementacao
    extends AtualizarClienteDataSource {
  final http.Client client;

  AtualizarclienteDataSourceImplementacao({required this.client});

  @override
  Future<bool> atualizarCliente(
      AtualizarClienteResquest atualizarClienteResquest) async {
    final response = await client.post(Endpoints.atualizarClienteWeb(),
        headers: AuthInterceptor().getHeadersAtualizarCliente(
            atualizarClienteResquest.tokenClienteWeb!),
        body: jsonEncode(atualizarClienteResquest.toJson()));

    if (response.statusCode == Constants.STATUS_CODE_200) {
      return true;
    }

    throw new Exception();
  }
}
