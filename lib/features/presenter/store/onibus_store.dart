import 'package:flutter_triple/flutter_triple.dart';
import 'package:montesBelos/features/data/models/onibus_request.dart';
import 'package:montesBelos/features/domain/entities/onibus.dart';
import 'package:montesBelos/features/domain/usecases/onibus_use_case.dart';

class OnibusStore extends NotifierStore<Exception, Onibus> {
  final OnibusUseCase onibusUseCase;

  OnibusStore(this.onibusUseCase) : super(Onibus());

  getLayoutDoOnibus(OnibusRequest onibusRequest) async {
    setLoading(true);
    final result = await onibusUseCase(onibusRequest);
    result.fold((error) {
      setError(error);
      setLoading(false);
    }, (sucesso) {
      update(sucesso);
      setLoading(false);
    });
  }
}
