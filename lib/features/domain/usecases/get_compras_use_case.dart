import 'package:dartz/dartz.dart';
import 'package:montesBelos/core/usecase/use_case.dart';
import 'package:montesBelos/features/domain/entities/get_compras.dart';
import 'package:montesBelos/features/domain/repositories/get_compras_repository.dart';

class GetComprasUseCase implements UseCase<GetCompras, String> {
  GetComprasRepository getComprasRepository;

  GetComprasUseCase(this.getComprasRepository);

  @override
  Future<Either<Exception, GetCompras>> call(String tokenDoCliente) async {
    return await getComprasRepository.getCompras(tokenDoCliente);
  }
}
