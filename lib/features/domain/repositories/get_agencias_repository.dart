import 'package:dartz/dartz.dart';
import 'package:montesBelos/features/data/models/get_agencias_request.dart';
import 'package:montesBelos/features/domain/entities/agencia.dart';

abstract class GetAgenciasRepository {
  Future<Either<Exception, List<Agencia>>> getAgencias(
      GetAgenciasRequest getAgenciasRequest);

  Future<Either<Exception, Agencia>> getAgenciaPorNome(
      String nome, int busCompany);
}
