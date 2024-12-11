import 'package:dartz/dartz.dart';
import 'package:montesBelos/core/usecase/use_case.dart';
import 'package:montesBelos/features/data/models/fale_conosco_request.dart';
import 'package:montesBelos/features/domain/repositories/fale_conosco_repository.dart';

class FaleConoscoUseCase implements UseCase<String, FaleConoscoRequest> {
  FaleConoscoRepository faleConoscoRepository;

  FaleConoscoUseCase(this.faleConoscoRepository);

  @override
  Future<Either<Exception, String>> call(
      FaleConoscoRequest faleConoscoRequest) async {
    return await faleConoscoRepository.enviarNotificacao(faleConoscoRequest);
  }
}
