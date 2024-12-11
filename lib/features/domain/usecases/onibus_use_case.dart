import 'package:dartz/dartz.dart';
import 'package:montesBelos/core/usecase/use_case.dart';
import 'package:montesBelos/features/data/models/onibus_request.dart';
import 'package:montesBelos/features/domain/entities/onibus.dart';
import 'package:montesBelos/features/domain/repositories/onibus_repository.dart';

class OnibusUseCase implements UseCase<Onibus, OnibusRequest> {
  OnibusRepository onibusRepository;

  OnibusUseCase(this.onibusRepository);

  @override
  Future<Either<Exception, Onibus>> call(OnibusRequest onibusRequest) async {
    return await onibusRepository.getLayoutDoOnibus(onibusRequest);
  }
}
