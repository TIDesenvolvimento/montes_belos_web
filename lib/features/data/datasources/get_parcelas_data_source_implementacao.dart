import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:montesBelos/core/utils/builder/auth_interceptor.dart';
import 'package:montesBelos/core/utils/constants/constants.dart';
import 'package:montesBelos/features/data/datasources/endpoints/endpoints.dart';
import 'package:montesBelos/features/data/datasources/get_parcelas_data_source.dart';
import 'package:montesBelos/features/data/models/parcela_response.dart';

class GetParcelasDataSourceImplementacao extends GetParcelasDataSource {
  final http.Client client;

  GetParcelasDataSourceImplementacao({required this.client});

  @override
  Future<ParcelaResponse> getParcelas() async {
    final response = await client.get(
      Endpoints.getParcelas(),
      headers: AuthInterceptor().getHeaders(),
    );
    if (response.statusCode == Constants.STATUS_CODE_200) {
      return ParcelaResponse.fromJson(json.decode(response.body));
    }
    throw new Exception();
  }
}
