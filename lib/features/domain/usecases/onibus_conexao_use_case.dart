import 'package:dartz/dartz.dart';
import 'package:montesBelos/core/usecase/use_case.dart';
import 'package:montesBelos/features/data/models/onibus_request.dart';
import 'package:montesBelos/features/domain/entities/onibus.dart';
import 'package:montesBelos/features/domain/repositories/onibus_conexao_repository.dart';

class OnibusConexaoUseCase implements UseCase<List<Onibus>, OnibusRequest> {
  OnibusConexaoRepository onibusConexaoRepository;

  OnibusConexaoUseCase(this.onibusConexaoRepository);

  @override
  Future<Either<Exception, List<Onibus>>> call(
      OnibusRequest onibusRequest) async {
    return await onibusConexaoRepository
        .getLayoutDoOnibusConexao(onibusRequest);
  }
}
