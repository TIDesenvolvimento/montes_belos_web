import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:montesBelos/core/utils/builder/auth_interceptor.dart';
import 'package:montesBelos/core/utils/constants/constants.dart';
import 'package:montesBelos/features/data/datasources/endpoints/endpoints.dart';
import 'package:montesBelos/features/data/datasources/get_agencias_data_source.dart';
import 'package:montesBelos/features/data/models/get_agencias_request.dart';
import 'package:montesBelos/features/data/models/get_agencias_response.dart';

class GetAgenciasDataSourceImplementacao extends GetAgenciasDataSource {
  final http.Client client;

  GetAgenciasDataSourceImplementacao({required this.client});

  @override
  Future<GetAgenciasResponse> getAgencias(
      GetAgenciasRequest getAgenciasRequest) async {
    final response = await client.get(
      Endpoints.getAgencias(getAgenciasRequest.valorInseridoPeloUsuario!),
      headers: AuthInterceptor().getHeaders(),
    );
    if (response.statusCode == Constants.STATUS_CODE_200) {
      return GetAgenciasResponse.fromJson(json.decode(response.body));
    }
    throw new Exception();
  }

  @override
  Future<GetAgenciasResponse> getAgenciasPorNome(
      String nome, int busCompany) async {
    final response = await client.get(
      Endpoints.getAgencias(nome),
      headers: AuthInterceptor().getHeadersTrecho(busCompany),
    );
    if (response.statusCode == Constants.STATUS_CODE_200) {
      return GetAgenciasResponse.fromJson(json.decode(response.body));
    }
    throw new Exception();
  }
}
