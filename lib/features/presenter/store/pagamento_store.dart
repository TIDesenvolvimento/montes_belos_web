import 'package:flutter_triple/flutter_triple.dart';
import 'package:montesBelos/features/data/models/purchase_request.dart';
import 'package:montesBelos/features/domain/usecases/pagamento_use_case.dart';

class PagamentoStore extends NotifierStore<Exception, String> {
  final PagamentoUseCase pagamentoUseCase;

  PagamentoStore(this.pagamentoUseCase) : super('');

  realizarPagamento(PurchaseRequest purchaseRequest) async {
    setLoading(true);
    final result = await pagamentoUseCase(purchaseRequest);
    result.fold((error) {
      setLoading(false);
      setError(error);
    }, (sucesso) {
      update(sucesso);
      setLoading(false);
    });
    setLoading(false);
  }
}
