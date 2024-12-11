import 'package:dartz/dartz.dart';
import 'package:montesBelos/core/usecase/use_case.dart';
import 'package:montesBelos/features/data/models/get_viagens_request.dart';
import 'package:montesBelos/features/domain/entities/viagem.dart';
import 'package:montesBelos/features/domain/repositories/get_viagens_repository.dart';

class GetViagensUseCase implements UseCase<List<Viagem>, GetViagensRequest> {
  GetViagensRepository getViagensRepository;

  GetViagensUseCase(this.getViagensRepository);

  @override
  Future<Either<Exception, List<Viagem>>> call(
      GetViagensRequest getViagensRequest) async {
    return await getViagensRepository.getViagens(getViagensRequest);
  }
}
