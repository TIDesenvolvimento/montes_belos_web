import 'package:dartz/dartz.dart';
import 'package:montesBelos/features/data/models/fale_conosco_request.dart';

abstract class FaleConoscoRepository {
  Future<Either<Exception, String>> enviarNotificacao(
      FaleConoscoRequest faleConoscoRequest);
}
