import 'package:montesBelos/features/data/models/atualizar_cliente_request.dart';

abstract class AtualizarClienteDataSource {
  Future<bool> atualizarCliente(
      AtualizarClienteResquest atualizarClienteResquest);
}
