import 'package:dartz/dartz.dart';
import 'package:montesBelos/core/utils/constants/constants.dart';
import 'package:montesBelos/core/utils/constants/strings.dart';
import 'package:montesBelos/features/data/datasources/get_telefone_das_agencias_data_source.dart';
import 'package:montesBelos/features/data/models/get_telefone_das_agencias_request.dart';
import 'package:montesBelos/features/data/models/get_telefone_das_agencias_response.dart';
import 'package:montesBelos/features/domain/entities/login_status.dart';
import 'package:montesBelos/features/domain/repositories/get_telefone_das_agencias_repository.dart';

class GetTelefoneDasAgenciasRepositoryImplementacao
    extends GetTelefoneDasAgenciasRepository {
  GetTelefoneDasAgenciasDataSource getTelefoneDasAgenciasDataSource;
  late LoginStatus loginStatus;

  GetTelefoneDasAgenciasRepositoryImplementacao(
      this.getTelefoneDasAgenciasDataSource);

  @override
  Future<Either<Exception, List<AgenciaData>>> getTelefoneDasAgencias(
      GetTelefoneDasAgenciasRequest getTelefoneDasAgenciasRequest) async {
    try {
      final result = await getTelefoneDasAgenciasDataSource
          .getTelefoneDasAgencias(getTelefoneDasAgenciasRequest);
      if (result.success == Constants.STATUS_SUCESS) {
        return Right(result.data);
      }
      return Left(Exception(result.mensagem));
    } on Exception {
      return Left(Exception(falha_interna_no_servidor));
    }
  }
}
