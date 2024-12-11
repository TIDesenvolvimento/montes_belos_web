import 'package:dartz/dartz.dart';
import 'package:montesBelos/features/data/models/cancelamento_request.dart';

abstract class CancelarVoucherRepository {
  Future<Either<Exception, bool>> cancelarVoucher(
      CancelamentoRequest cancelamentoRequest);
}
