import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:montesBelos/core/utils/builder/auth_interceptor.dart';
import 'package:montesBelos/core/utils/constants/constants.dart';
import 'package:montesBelos/features/data/datasources/endpoints/endpoints.dart';
import 'package:montesBelos/features/data/datasources/onibus_data_source.dart';
import 'package:montesBelos/features/data/models/onibus_request.dart';
import 'package:montesBelos/features/data/models/onibus_response.dart';

class OnibusDataSourceImplementacao extends OnibusDataSource {
  final http.Client client;

  OnibusDataSourceImplementacao({required this.client});

  @override
  Future<OnibusResponse> getLayoutDoOnibus(OnibusRequest onibusRequest) async {
    final response = await client.get(
      Endpoints.getLayoutDoOnibus(onibusRequest),
      headers: AuthInterceptor().getHeaders(),
    );
    if (response.statusCode == Constants.STATUS_CODE_200) {
      return OnibusResponse.fromJson(json.decode(response.body));
    }
    throw new Exception();
  }
}
