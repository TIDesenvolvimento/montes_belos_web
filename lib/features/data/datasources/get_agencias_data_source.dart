import 'package:montesBelos/features/data/models/get_agencias_request.dart';
import 'package:montesBelos/features/data/models/get_agencias_response.dart';

abstract class GetAgenciasDataSource {
  Future<GetAgenciasResponse> getAgencias(
      GetAgenciasRequest getAgenciasRequest);
  Future<GetAgenciasResponse> getAgenciasPorNome(String nome, int busCompany);
}
