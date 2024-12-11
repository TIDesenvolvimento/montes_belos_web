import 'package:flutter_triple/flutter_triple.dart';
import 'package:montesBelos/features/data/models/cancelamento_request.dart';
import 'package:montesBelos/features/domain/usecases/cancelar_voucher_use_case.dart';

class CancelarVoucherStore extends NotifierStore<Exception, bool> {
  final CancelarVoucherUseCase cancelarVoucherUseCase;

  CancelarVoucherStore(this.cancelarVoucherUseCase) : super(false);

  cancelarVoucher(CancelamentoRequest cancelamentoRequest) async {
    setLoading(true);
    final result = await cancelarVoucherUseCase(cancelamentoRequest);
    result.fold((error) {
      setLoading(false);
      setError(error);
    }, (sucesso) {
      setLoading(false);
      update(true);
    });
    setLoading(true);
  }
}
