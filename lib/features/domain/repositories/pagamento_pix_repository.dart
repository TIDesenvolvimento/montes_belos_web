import 'package:dartz/dartz.dart';
import 'package:montesBelos/features/data/models/purchase_request.dart';
import 'package:montesBelos/features/domain/entities/pagamento_pix_status.dart';

abstract class PagamentoViaPixRepository {
  Future<Either<Exception, PagamentoViaPixStatus>> realizarPagamento(
      PurchaseRequest purchaseRequest);
}
