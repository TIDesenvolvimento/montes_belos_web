import 'package:flutter_triple/flutter_triple.dart';
import 'package:montesBelos/features/data/models/get_telefone_das_agencias_request.dart';
import 'package:montesBelos/features/data/models/get_telefone_das_agencias_response.dart';
import 'package:montesBelos/features/domain/usecases/get_telefone_das_agencias_use_case.dart';

class GetTelefoneDasAgenciasStore
    extends NotifierStore<Exception, List<AgenciaData>> {
  final GetTelefoneDasAgenciasUseCase getTelefoneDasAgenciasUseCase;

  GetTelefoneDasAgenciasStore(this.getTelefoneDasAgenciasUseCase) : super([]);

  getTelefoneDasAgencias(
      GetTelefoneDasAgenciasRequest getTelefoneDasAgenciasRequest) async {
    setLoading(true);
    final result =
        await getTelefoneDasAgenciasUseCase(getTelefoneDasAgenciasRequest);
    result.fold((error) {
      setLoading(false);
      setError(error);
    }, (sucesso) {
      setLoading(false);
      update(sucesso);
    });
    setLoading(true);
  }
}
