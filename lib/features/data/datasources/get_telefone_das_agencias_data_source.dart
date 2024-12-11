import 'package:montesBelos/features/data/models/get_telefone_das_agencias_request.dart';
import 'package:montesBelos/features/data/models/get_telefone_das_agencias_response.dart';

abstract class GetTelefoneDasAgenciasDataSource {
  Future<GetTelefoneDasAgenciasResponse> getTelefoneDasAgencias(
      GetTelefoneDasAgenciasRequest getTelefoneDasAgenciasRequest);
}
