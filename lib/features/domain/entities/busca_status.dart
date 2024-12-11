import 'package:montesBelos/features/data/models/purchase_request.dart';

class BuscaStatus {
  Trecho trechoIda = Trecho();
  Trecho trechoVolta = Trecho();

  BuscaStatus({required this.trechoIda, required this.trechoVolta});
}
