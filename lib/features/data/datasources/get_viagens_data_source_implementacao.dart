import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:montesBelos/core/utils/builder/auth_interceptor.dart';
import 'package:montesBelos/core/utils/constants/constants.dart';
import 'package:montesBelos/features/data/datasources/endpoints/endpoints.dart';
import 'package:montesBelos/features/data/datasources/get_viagens_data_source.dart';
import 'package:montesBelos/features/data/models/get_viagens_request.dart';
import 'package:montesBelos/features/data/models/get_viagens_response.dart';

class GetViagensDataSourceImplementacao extends GetViagensDataSource {
  final http.Client client;

  GetViagensDataSourceImplementacao({required this.client});

  @override
  Future<GetViagensResponse> getViagens(
      GetViagensRequest getViagensRequest) async {
    final response = await client.get(
      Endpoints.getViagens(getViagensRequest),
      headers: AuthInterceptor().getHeaders(),
    );
    if (response.statusCode == Constants.STATUS_CODE_200) {
      return GetViagensResponse.fromJson(json.decode(response.body));
    }
    throw new Exception();
  }
}
