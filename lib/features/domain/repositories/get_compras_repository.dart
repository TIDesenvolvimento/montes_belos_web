import 'package:dartz/dartz.dart';
import 'package:montesBelos/features/domain/entities/get_compras.dart';

abstract class GetComprasRepository {
  Future<Either<Exception, GetCompras>> getCompras(String tokenDoCliente);
}
