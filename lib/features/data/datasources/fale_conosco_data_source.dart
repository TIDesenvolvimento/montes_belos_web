import 'package:montesBelos/features/data/models/fale_conosco_request.dart';
import 'package:montesBelos/features/data/models/fale_conosco_response.dart';

abstract class FaleConoscoDataSource {
  Future<FaleConoscoResponse> enviarNotificacao(
      FaleConoscoRequest faleConoscoRequest);
}
