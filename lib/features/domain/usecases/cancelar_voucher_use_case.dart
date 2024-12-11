import 'package:dartz/dartz.dart';
import 'package:montesBelos/core/usecase/use_case.dart';
import 'package:montesBelos/features/data/models/cancelamento_request.dart';
import 'package:montesBelos/features/domain/repositories/cancelar_voucher_repository.dart';

class CancelarVoucherUseCase implements UseCase<bool, CancelamentoRequest> {
  CancelarVoucherRepository cancelarVoucherRepository;

  CancelarVoucherUseCase(this.cancelarVoucherRepository);

  @override
  Future<Either<Exception, bool>> call(
      CancelamentoRequest cancelamentoRequest) async {
    return await cancelarVoucherRepository.cancelarVoucher(cancelamentoRequest);
  }
}
