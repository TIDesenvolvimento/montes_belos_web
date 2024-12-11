import 'package:dartz/dartz.dart';
import 'package:montesBelos/core/utils/constants/strings.dart';
import 'package:montesBelos/features/data/datasources/cancelar_voucher_data_source.dart';
import 'package:montesBelos/features/data/models/cancelamento_request.dart';
import 'package:montesBelos/features/domain/entities/login_status.dart';
import 'package:montesBelos/features/domain/repositories/cancelar_voucher_repository.dart';

class CancelarVoucherRepositoryImplementacao extends CancelarVoucherRepository {
  CancelarVoucherDataSource cancelarVoucherDataSource;
  late LoginStatus loginStatus;

  CancelarVoucherRepositoryImplementacao(this.cancelarVoucherDataSource);

  @override
  Future<Either<Exception, bool>> cancelarVoucher(
      CancelamentoRequest cancelamentoRequest) async {
    try {
      final result =
          await cancelarVoucherDataSource.cancelarVoucher(cancelamentoRequest);
      if (result) {
        return Right(true);
      }
      return Left(Exception(cancelar_voucher__text_erro_ao_cancelar_voucher));
    } on Exception {
      return Left(Exception(falha_interna_no_servidor));
    }
  }
}
