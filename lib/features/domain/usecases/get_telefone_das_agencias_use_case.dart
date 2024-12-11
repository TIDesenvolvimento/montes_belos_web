import 'package:dartz/dartz.dart';
import 'package:montesBelos/core/usecase/use_case.dart';
import 'package:montesBelos/features/data/models/get_telefone_das_agencias_request.dart';
import 'package:montesBelos/features/data/models/get_telefone_das_agencias_response.dart';
import 'package:montesBelos/features/domain/repositories/get_telefone_das_agencias_repository.dart';

class GetTelefoneDasAgenciasUseCase
    implements UseCase<List<AgenciaData>, GetTelefoneDasAgenciasRequest> {
  GetTelefoneDasAgenciasRepository getTelefoneDasAgenciasRepository;

  GetTelefoneDasAgenciasUseCase(this.getTelefoneDasAgenciasRepository);

  @override
  Future<Either<Exception, List<AgenciaData>>> call(
      GetTelefoneDasAgenciasRequest getTelefoneDasAgenciasRequest) async {
    return await getTelefoneDasAgenciasRepository
        .getTelefoneDasAgencias(getTelefoneDasAgenciasRequest);
  }
}
