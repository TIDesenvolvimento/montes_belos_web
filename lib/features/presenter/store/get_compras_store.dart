import 'package:flutter_triple/flutter_triple.dart';
import 'package:montesBelos/features/domain/entities/get_compras.dart';
import 'package:montesBelos/features/domain/usecases/get_compras_use_case.dart';

class ComprasStore extends NotifierStore<Exception, GetCompras> {
  final GetComprasUseCase getComprasUseCase;

  ComprasStore(this.getComprasUseCase) : super(GetCompras());

  getCompras(String tokenDoCliente) async {
    setLoading(true);
    final result = await getComprasUseCase(tokenDoCliente);
    result.fold((error) {
      setLoading(false);
      setError(error);
    }, (sucesso) {
      setLoading(false);
      update(sucesso);
    });
    setLoading(false);
  }
}
