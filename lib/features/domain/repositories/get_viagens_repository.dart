import 'package:dartz/dartz.dart';
import 'package:montesBelos/features/data/models/get_viagens_request.dart';
import 'package:montesBelos/features/domain/entities/viagem.dart';

abstract class GetViagensRepository {
  Future<Either<Exception, List<Viagem>>> getViagens(
      GetViagensRequest getViagensRequest);
}
