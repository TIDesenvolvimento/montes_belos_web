import 'package:montesBelos/features/data/models/cancelamento_request.dart';

abstract class CancelarVoucherDataSource {
  Future<bool> cancelarVoucher(CancelamentoRequest cancelamentoRequest);
}
