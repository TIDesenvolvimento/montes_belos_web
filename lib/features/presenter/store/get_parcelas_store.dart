import 'package:flutter_triple/flutter_triple.dart';
import 'package:montesBelos/features/domain/entities/parcela_status.dart';
import 'package:montesBelos/features/domain/usecases/get_parcelas_use_case.dart';

class ParcelaStore extends NotifierStore<Exception, ParcelaStatus> {
  final GetParcelasUseCase getParcelasUseCase;

  ParcelaStore(this.getParcelasUseCase) : super(ParcelaStatus());

  getParcelas() async {
    setLoading(true);
    final result = await getParcelasUseCase(true);
    result.fold((error) {
      setError(error);
      setLoading(false);
    }, (sucesso) {
      update(sucesso);
      setLoading(false);
    });
    setLoading(false);
  }
}
