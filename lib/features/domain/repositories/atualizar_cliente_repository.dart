import 'package:dartz/dartz.dart';
import 'package:montesBelos/features/data/models/atualizar_cliente_request.dart';

abstract class AtualizarClienteRepository {
  Future<Either<Exception, bool>> atualizarCliente(
      AtualizarClienteResquest atualizarClienteResquest);
}
