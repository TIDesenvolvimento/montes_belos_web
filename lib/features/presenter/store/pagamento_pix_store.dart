import 'package:flutter_triple/flutter_triple.dart';
import 'package:montesBelos/features/data/models/purchase_request.dart';
import 'package:montesBelos/features/domain/entities/pagamento_pix_status.dart';
import 'package:montesBelos/features/domain/usecases/pagamento_pix_use_case.dart';

class PagamentoViaPixStore
    extends NotifierStore<Exception, PagamentoViaPixStatus> {
  final PagamentoViaPixUseCase pagamentoViaPixUseCase;

  PagamentoViaPixStore(this.pagamentoViaPixUseCase)
      : super(PagamentoViaPixStatus());

  realizarPagamento(PurchaseRequest purchaseRequest) async {
    setLoading(true);
    final result = await pagamentoViaPixUseCase(purchaseRequest);
    result.fold((error) {
      setLoading(false);
      setError(error);
    }, (sucesso) {
      setLoading(false);
      update(sucesso);
    });
    setLoading(false);
  }
}
