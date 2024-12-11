import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:montesBelos/core/utils/builder/auth_interceptor.dart';
import 'package:montesBelos/core/utils/constants/constants.dart';
import 'package:montesBelos/features/data/datasources/endpoints/endpoints.dart';
import 'package:montesBelos/features/data/datasources/pagamento_data_source.dart';
import 'package:montesBelos/features/data/models/pagamento_response.dart';
import 'package:montesBelos/features/data/models/purchase_request.dart';

class PagamentoDataSourceImplementacao extends PagamentoDataSource {
  final http.Client client;

  PagamentoDataSourceImplementacao({required this.client});

  @override
  Future<PagamentoResponse> realizarPagamento(
      PurchaseRequest purchaseRequest) async {
    final response = await client.post(Endpoints.realizarPagamento(),
        headers: AuthInterceptor().getHeadersPurchaseCreate(
            purchaseRequest.clienteWeb!.tokenClienteWeb!),
        body: jsonEncode(purchaseRequest.toJson()));

    if (response.statusCode == Constants.STATUS_CODE_200 ||
        response.statusCode == Constants.STATUS_CODE_500) {
      return PagamentoResponse.fromJson(json.decode(response.body));
    }

    throw new Exception();
  }
}
