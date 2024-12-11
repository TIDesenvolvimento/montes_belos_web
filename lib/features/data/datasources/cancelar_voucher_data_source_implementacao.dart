import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:montesBelos/core/utils/builder/auth_interceptor.dart';
import 'package:montesBelos/core/utils/constants/constants.dart';
import 'package:montesBelos/features/data/datasources/cancelar_voucher_data_source.dart';
import 'package:montesBelos/features/data/datasources/endpoints/endpoints.dart';
import 'package:montesBelos/features/data/models/cancelamento_request.dart';

class CancelarVoucherDataSourceImplementacao extends CancelarVoucherDataSource {
  final http.Client client;

  CancelarVoucherDataSourceImplementacao({required this.client});

  @override
  Future<bool> cancelarVoucher(CancelamentoRequest cancelamentoRequest) async {
    final response = await client.post(Endpoints.cancelarVoucher(),
        headers: AuthInterceptor().getHeadersFaleConosco(),
        body: jsonEncode(cancelamentoRequest.toJson()));

    if (response.statusCode == Constants.STATUS_CODE_200) {
      return true;
    }

    throw new Exception();
  }
}
