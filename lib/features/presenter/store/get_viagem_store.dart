import 'package:flutter_triple/flutter_triple.dart';
import 'package:montesBelos/features/data/models/get_viagens_request.dart';
import 'package:montesBelos/features/domain/entities/viagem.dart';
import 'package:montesBelos/features/domain/usecases/get_viagens_use_case.dart';

class ViagemStore extends NotifierStore<Exception, List<Viagem>> {
  final GetViagensUseCase getViagensUseCase;

  ViagemStore(this.getViagensUseCase) : super([]);

  getViagens(GetViagensRequest getViagensRequest) async {
    setLoading(true);

    final result = await getViagensUseCase(getViagensRequest);
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
