import 'package:dartz/dartz.dart';
import 'package:montesBelos/core/utils/constants/strings.dart';
import 'package:montesBelos/features/data/datasources/atualizar_cliente_data_sorce.dart';
import 'package:montesBelos/features/data/models/atualizar_cliente_request.dart';
import 'package:montesBelos/features/domain/entities/login_status.dart';
import 'package:montesBelos/features/domain/repositories/atualizar_cliente_repository.dart';

class AtualizarClienteRepositoryImplementacao
    extends AtualizarClienteRepository {
  AtualizarClienteDataSource atualizarClienteDataSource;
  late LoginStatus loginStatus;

  AtualizarClienteRepositoryImplementacao(this.atualizarClienteDataSource);

  @override
  Future<Either<Exception, bool>> atualizarCliente(
      AtualizarClienteResquest atualizarClienteResquest) async {
    try {
      final result = await atualizarClienteDataSource
          .atualizarCliente(atualizarClienteResquest);
      if (result) {
        return Right(true);
      }
      return Left(Exception(atualizar_cliente__text_erro_ao_atualizar_dados));
    } on Exception {
      return Left(Exception(falha_interna_no_servidor));
    }
  }
}
