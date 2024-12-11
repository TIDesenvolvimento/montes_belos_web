import 'package:dartz/dartz.dart';
import 'package:montesBelos/core/usecase/use_case.dart';
import 'package:montesBelos/features/data/models/get_agencias_request.dart';
import 'package:montesBelos/features/domain/entities/agencia.dart';
import 'package:montesBelos/features/domain/repositories/get_agencias_repository.dart';

class GetAgenciasUseCase implements UseCase<List<Agencia>, GetAgenciasRequest> {
  GetAgenciasRepository getAgenciasRepository;

  GetAgenciasUseCase(this.getAgenciasRepository);

  @override
  Future<Either<Exception, List<Agencia>>> call(
      GetAgenciasRequest getAgenciasRequest) async {
    return await getAgenciasRepository.getAgencias(getAgenciasRequest);
  }

  Future<Either<Exception, Agencia>> getAgenciaPorNome(
      String nome, int busCompany) async {
    return await getAgenciasRepository.getAgenciaPorNome(nome, busCompany);
  }
}
