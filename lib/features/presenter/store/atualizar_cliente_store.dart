import 'package:flutter_triple/flutter_triple.dart';
import 'package:montesBelos/features/data/models/atualizar_cliente_request.dart';
import 'package:montesBelos/features/domain/usecases/atualizar_cliente_use_case.dart';

class AtualizarClienteStore extends NotifierStore<Exception, bool> {
  final AtualizarClienteUseCase atualizarClienteUseCase;

  AtualizarClienteStore(this.atualizarClienteUseCase) : super(false);

  atualizarCliente(AtualizarClienteResquest atualizarClienteResquest) async {
    setLoading(true);
    final result = await atualizarClienteUseCase(atualizarClienteResquest);
    result.fold((error) {
      setLoading(false);
      setError(error);
    }, (sucesso) {
      setLoading(false);
      update(true);
    });
    setLoading(true);
  }
}
