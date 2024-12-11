import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:montesBelos/core/utils/builder/auth_interceptor.dart';
import 'package:montesBelos/core/utils/constants/constants.dart';
import 'package:montesBelos/features/data/datasources/endpoints/endpoints.dart';
import 'package:montesBelos/features/data/datasources/fale_conosco_data_source.dart';
import 'package:montesBelos/features/data/models/fale_conosco_request.dart';
import 'package:montesBelos/features/data/models/fale_conosco_response.dart';

class FaleConoscoDataSourceImplementacao extends FaleConoscoDataSource {
  final http.Client client;

  FaleConoscoDataSourceImplementacao({required this.client});

  @override
  Future<FaleConoscoResponse> enviarNotificacao(
      FaleConoscoRequest faleConoscoRequest) async {
    final response = await client.put(
      Endpoints.enviarNotificacaoFaleConosco(),
      headers: AuthInterceptor().getHeadersFaleConosco(),
      body: jsonEncode(faleConoscoRequest.toJson()),
    );

    if (response.statusCode == Constants.STATUS_CODE_200) {
      return FaleConoscoResponse.fromJson(jsonDecode(response.body));
    }

    throw Exception('Erro ao enviar a notificação: ${response.statusCode}');
  }
}
