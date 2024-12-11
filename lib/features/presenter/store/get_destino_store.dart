import 'package:flutter_triple/flutter_triple.dart';
import 'package:montesBelos/features/data/models/get_agencias_request.dart';
import 'package:montesBelos/features/domain/entities/agencia.dart';
import 'package:montesBelos/features/domain/usecases/get_agencias_use_case.dart';

class DestinoStore extends NotifierStore<Exception, List<Agencia>> {
  final GetAgenciasUseCase getAgenciasUseCase;

  DestinoStore(this.getAgenciasUseCase) : super([]);

  getAgenciasDeDestino(GetAgenciasRequest getAgenciasRequest) async {
    final result = await getAgenciasUseCase(getAgenciasRequest);
    result.fold((error) {
      setError(error);
    }, (sucesso) {
      update(sucesso);
    });
  }
}
