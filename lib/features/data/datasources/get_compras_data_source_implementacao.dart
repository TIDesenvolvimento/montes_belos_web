import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:montesBelos/core/utils/builder/auth_interceptor.dart';
import 'package:montesBelos/core/utils/constants/constants.dart';
import 'package:montesBelos/features/data/datasources/endpoints/endpoints.dart';
import 'package:montesBelos/features/data/datasources/get_compras_data_source.dart';
import 'package:montesBelos/features/data/models/get_compras_response.dart';

class GetComprasDataSourceImplementacao extends GetComprasDataSource {
  final http.Client client;

  GetComprasDataSourceImplementacao({required this.client});

  @override
  Future<GetComprasReponse> getCompras(String tokenDoCliente) async {
    final response = await client.get(
      Endpoints.getCompras(),
      headers: AuthInterceptor().getHeadersMinhasCompras(tokenDoCliente),
    );
    if (response.statusCode == Constants.STATUS_CODE_200) {
      return GetComprasReponse.fromJson(json.decode(response.body));
    }
    throw new Exception();
  }
}
