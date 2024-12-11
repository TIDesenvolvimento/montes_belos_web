import 'package:dartz/dartz.dart';

abstract class UseCase<Resultado, Entrada> {
  Future<Either<Exception, Resultado>> call(Entrada parametros);
}
