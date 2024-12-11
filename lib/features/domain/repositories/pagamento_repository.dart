import 'package:dartz/dartz.dart';
import 'package:montesBelos/features/data/models/purchase_request.dart';

abstract class PagamentoRepository {
  Future<Either<Exception, String>> realizarPagamento(
      PurchaseRequest purchaseRequest);
}
