import 'package:dartz/dartz.dart';
import 'package:montesBelos/features/data/models/onibus_request.dart';
import 'package:montesBelos/features/domain/entities/onibus.dart';

abstract class OnibusConexaoRepository {
  Future<Either<Exception, List<Onibus>>> getLayoutDoOnibusConexao(
      OnibusRequest onibusRequest);
}
