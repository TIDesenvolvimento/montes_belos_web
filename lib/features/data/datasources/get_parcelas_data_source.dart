import 'package:montesBelos/features/data/models/parcela_response.dart';

abstract class GetParcelasDataSource {
  Future<ParcelaResponse> getParcelas();
}
