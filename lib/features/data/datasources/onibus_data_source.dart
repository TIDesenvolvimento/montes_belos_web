import 'package:montesBelos/features/data/models/onibus_request.dart';
import 'package:montesBelos/features/data/models/onibus_response.dart';

abstract class OnibusDataSource {
  Future<OnibusResponse> getLayoutDoOnibus(OnibusRequest onibusRequest);
}
