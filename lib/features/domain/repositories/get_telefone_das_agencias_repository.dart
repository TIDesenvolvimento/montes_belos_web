import 'package:dartz/dartz.dart';
import 'package:montesBelos/features/data/models/get_telefone_das_agencias_request.dart';
import 'package:montesBelos/features/data/models/get_telefone_das_agencias_response.dart';

abstract class GetTelefoneDasAgenciasRepository {
  Future<Either<Exception, List<AgenciaData>>> getTelefoneDasAgencias(
      GetTelefoneDasAgenciasRequest getTelefoneDasAgenciasRequest);
}
