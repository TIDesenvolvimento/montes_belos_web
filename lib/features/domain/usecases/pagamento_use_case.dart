import 'package:dartz/dartz.dart';
import 'package:montesBelos/core/usecase/use_case.dart';
import 'package:montesBelos/features/data/models/purchase_request.dart';
import 'package:montesBelos/features/domain/repositories/pagamento_repository.dart';

class PagamentoUseCase implements UseCase<String, PurchaseRequest> {
  PagamentoRepository pagamentoRepository;

  PagamentoUseCase(this.pagamentoRepository);

  @override
  Future<Either<Exception, String>> call(
      PurchaseRequest purchaseRequest) async {
    return await pagamentoRepository.realizarPagamento(purchaseRequest);
  }
}
