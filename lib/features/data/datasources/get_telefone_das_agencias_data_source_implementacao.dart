import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:montesBelos/core/utils/builder/auth_interceptor.dart';
import 'package:montesBelos/core/utils/constants/constants.dart';
import 'package:montesBelos/features/data/datasources/endpoints/endpoints.dart';
import 'package:montesBelos/features/data/datasources/get_telefone_das_agencias_data_source.dart';
import 'package:montesBelos/features/data/models/get_telefone_das_agencias_request.dart';
import 'package:montesBelos/features/data/models/get_telefone_das_agencias_response.dart';

class GetTelefoneDasAgenciasDataSourceImplementacao
    extends GetTelefoneDasAgenciasDataSource {
  final http.Client client;

  GetTelefoneDasAgenciasDataSourceImplementacao({required this.client});

  @override
  Future<GetTelefoneDasAgenciasResponse> getTelefoneDasAgencias(
      GetTelefoneDasAgenciasRequest getTelefoneDasAgenciasRequest) async {
    final url =
        Endpoints.getTelefoneDasAgencias(getTelefoneDasAgenciasRequest.uf);

    final response = await client.get(
      url,
      headers: AuthInterceptor().getHeadersFaleConosco(),
    );

    if (response.statusCode == Constants.STATUS_CODE_200) {
      final jsonResponse = jsonDecode(response.body);
      return GetTelefoneDasAgenciasResponse.fromJson(jsonResponse);
    }

    throw Exception("Erro ao buscar telefone das agências");
  }
}
