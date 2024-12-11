import 'package:dartz/dartz.dart';
import 'package:montesBelos/core/usecase/use_case.dart';
import 'package:montesBelos/features/data/models/purchase_request.dart';
import 'package:montesBelos/features/domain/entities/pagamento_pix_status.dart';
import 'package:montesBelos/features/domain/repositories/pagamento_pix_repository.dart';

class PagamentoViaPixUseCase
    implements UseCase<PagamentoViaPixStatus, PurchaseRequest> {
  PagamentoViaPixRepository pagamentoViaPixRepository;

  PagamentoViaPixUseCase(this.pagamentoViaPixRepository);

  @override
  Future<Either<Exception, PagamentoViaPixStatus>> call(
      PurchaseRequest purchaseRequest) async {
    return await pagamentoViaPixRepository.realizarPagamento(purchaseRequest);
  }
}
