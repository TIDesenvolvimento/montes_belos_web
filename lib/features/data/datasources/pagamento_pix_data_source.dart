import 'package:montesBelos/features/data/models/pagamento_pix_response.dart';
import 'package:montesBelos/features/data/models/purchase_request.dart';

abstract class PagamentoViaPixDataSource {
  Future<PagamentoViaPixResponse> realizarPagamento(
      PurchaseRequest purchaseRequest);
}
