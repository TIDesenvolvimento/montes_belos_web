import 'package:montesBelos/features/data/models/onibus_conexao_response.dart';
import 'package:montesBelos/features/data/models/onibus_request.dart';

abstract class OnibusConexaoDataSource {
  Future<OnibusConexaoResponse> getLayoutDoOnibusConexao(
      OnibusRequest onibusRequest);
}
