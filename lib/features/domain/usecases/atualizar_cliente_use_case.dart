import 'package:dartz/dartz.dart';
import 'package:montesBelos/core/usecase/use_case.dart';
import 'package:montesBelos/features/data/models/atualizar_cliente_request.dart';
import 'package:montesBelos/features/domain/repositories/atualizar_cliente_repository.dart';

class AtualizarClienteUseCase
    implements UseCase<bool, AtualizarClienteResquest> {
  AtualizarClienteRepository atualizarClienteRepository;

  AtualizarClienteUseCase(this.atualizarClienteRepository);

  @override
  Future<Either<Exception, bool>> call(
      AtualizarClienteResquest atualizarClienteResquest) async {
    return await atualizarClienteRepository
        .atualizarCliente(atualizarClienteResquest);
  }
}
