import 'package:montesBelos/features/data/models/pagamento_response.dart';
import 'package:montesBelos/features/data/models/purchase_request.dart';

abstract class PagamentoDataSource {
  Future<PagamentoResponse> realizarPagamento(PurchaseRequest purchaseRequest);
}
