import 'package:montesBelos/features/data/models/get_viagens_request.dart';
import 'package:montesBelos/features/data/models/get_viagens_response.dart';

abstract class GetViagensDataSource {
  Future<GetViagensResponse> getViagens(GetViagensRequest getViagensRequest);
}
