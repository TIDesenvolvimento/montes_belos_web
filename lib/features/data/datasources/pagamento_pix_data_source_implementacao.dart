import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:montesBelos/core/utils/builder/auth_interceptor.dart';
import 'package:montesBelos/core/utils/constants/constants.dart';
import 'package:montesBelos/features/data/datasources/endpoints/endpoints.dart';
import 'package:montesBelos/features/data/datasources/pagamento_pix_data_source.dart';
import 'package:montesBelos/features/data/models/pagamento_pix_response.dart';
import 'package:montesBelos/features/data/models/purchase_request.dart';

class PagamentoViaPixDataSourceImplementacao extends PagamentoViaPixDataSource {
  final http.Client client;

  PagamentoViaPixDataSourceImplementacao({required this.client});

  @override
  Future<PagamentoViaPixResponse> realizarPagamento(
      PurchaseRequest purchaseRequest) async {
    final response = await client.post(Endpoints.realizarPagamento(),
        headers: AuthInterceptor().getHeadersPurchaseCreate(
            purchaseRequest.clienteWeb!.tokenClienteWeb!),
        body: jsonEncode(purchaseRequest.toJson()));

    if (response.statusCode == Constants.STATUS_CODE_200 ||
        response.statusCode == Constants.STATUS_CODE_500) {
      return PagamentoViaPixResponse.fromJson(json.decode(response.body));
    }

    throw new Exception();
  }
}
