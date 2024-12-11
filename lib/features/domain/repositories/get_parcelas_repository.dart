import 'package:dartz/dartz.dart';
import 'package:montesBelos/features/domain/entities/parcela_status.dart';

abstract class GetParcelasRepository {
  Future<Either<Exception, ParcelaStatus>> getParcelas(bool ativo);
}
