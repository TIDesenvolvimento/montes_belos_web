import 'package:montesBelos/features/data/models/get_compras_response.dart';

abstract class GetComprasDataSource {
  Future<GetComprasReponse> getCompras(String tokenDoCliente);
}
