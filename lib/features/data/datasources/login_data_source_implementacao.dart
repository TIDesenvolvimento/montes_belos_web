import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:montesBelos/core/utils/builder/auth_interceptor.dart';
import 'package:montesBelos/core/utils/constants/constants.dart';
import 'package:montesBelos/features/data/datasources/endpoints/endpoints.dart';
import 'package:montesBelos/features/data/datasources/login_data_source.dart';
import 'package:montesBelos/features/data/models/login_request.dart';
import 'package:montesBelos/features/data/models/login_response.dart';

class LoginDataSourceImplementacao extends LoginDataSource {
  final http.Client client;

  LoginDataSourceImplementacao({required this.client});

  @override
  Future<LoginResponse> realizarLogin(LoginRequest loginRequest) async {
    final response = await client.post(Endpoints.realizarLogin(),
        headers: AuthInterceptor().getHeadersClienteWeb(),
        body: jsonEncode(loginRequest.toJson()));

    if (response.statusCode == Constants.STATUS_CODE_200) {
      return LoginResponse.fromJson(json.decode(response.body));
    }

    throw new Exception();
  }
}
