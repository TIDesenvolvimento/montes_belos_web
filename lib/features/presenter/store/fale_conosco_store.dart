import 'package:flutter_triple/flutter_triple.dart';
import 'package:montesBelos/features/data/models/fale_conosco_request.dart';
import 'package:montesBelos/features/domain/usecases/fale_conosco_use_case.dart';

class FaleConoscoStore extends NotifierStore<Exception, String> {
  final FaleConoscoUseCase faleConoscoUseCase;

  FaleConoscoStore(this.faleConoscoUseCase) : super('');

  enviarNotificacao(FaleConoscoRequest faleConoscoRequest) async {
    setLoading(true);
    final result = await faleConoscoUseCase(faleConoscoRequest);
    result.fold((error) {
      setLoading(false);
      setError(error);
    }, (String sucesso) {
      setLoading(false);
      update(sucesso);
    });
    setLoading(true);
  }
}
