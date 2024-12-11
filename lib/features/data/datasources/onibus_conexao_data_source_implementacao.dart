import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:montesBelos/core/utils/builder/auth_interceptor.dart';
import 'package:montesBelos/core/utils/constants/constants.dart';
import 'package:montesBelos/features/data/datasources/endpoints/endpoints.dart';
import 'package:montesBelos/features/data/datasources/onibus_conexao_data_source.dart';
import 'package:montesBelos/features/data/models/onibus_conexao_response.dart';
import 'package:montesBelos/features/data/models/onibus_request.dart';

class OnibusConexaoDataSourceImplementacao extends OnibusConexaoDataSource {
  final http.Client client;

  OnibusConexaoDataSourceImplementacao({required this.client});

  @override
  Future<OnibusConexaoResponse> getLayoutDoOnibusConexao(
      OnibusRequest onibusRequest) async {
    final response = await client.get(
      Endpoints.getLayoutDoOnibusConexao(onibusRequest),
      headers: AuthInterceptor().getHeaders(),
    );
    if (response.statusCode == Constants.STATUS_CODE_200) {
      return OnibusConexaoResponse.fromJson(json.decode(response.body));
    }
    throw new Exception();
  }
}
