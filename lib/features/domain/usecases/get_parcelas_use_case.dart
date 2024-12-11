import 'package:dartz/dartz.dart';
import 'package:montesBelos/core/usecase/use_case.dart';
import 'package:montesBelos/features/domain/entities/parcela_status.dart';
import 'package:montesBelos/features/domain/repositories/get_parcelas_repository.dart';

class GetParcelasUseCase implements UseCase<ParcelaStatus, bool> {
  GetParcelasRepository getParcelasRepository;

  GetParcelasUseCase(this.getParcelasRepository);

  @override
  Future<Either<Exception, ParcelaStatus>> call(bool ativo) async {
    return await getParcelasRepository.getParcelas(ativo);
  }
}
