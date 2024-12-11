import 'package:dartz/dartz.dart';
import 'package:montesBelos/core/utils/constants/constants.dart';
import 'package:montesBelos/core/utils/constants/strings.dart';
import 'package:montesBelos/features/data/datasources/fale_conosco_data_source.dart';
import 'package:montesBelos/features/data/models/fale_conosco_request.dart';
import 'package:montesBelos/features/domain/entities/login_status.dart';
import 'package:montesBelos/features/domain/repositories/fale_conosco_repository.dart';

class FaleConoscoRepositoryImplementacao extends FaleConoscoRepository {
  FaleConoscoDataSource faleConoscoDataSource;
  late LoginStatus loginStatus;

  FaleConoscoRepositoryImplementacao(this.faleConoscoDataSource);

  @override
  Future<Either<Exception, String>> enviarNotificacao(
      FaleConoscoRequest faleConoscoRequest) async {
    try {
      final result =
          await faleConoscoDataSource.enviarNotificacao(faleConoscoRequest);
      if (result.success == Constants.STATUS_SUCESS) {
        return Right(result.mensagem);
      }
      return Left(Exception(fale_conosco__text_erro_enviar_notificacao));
    } on Exception {
      return Left(Exception(falha_interna_no_servidor));
    }
  }
}
