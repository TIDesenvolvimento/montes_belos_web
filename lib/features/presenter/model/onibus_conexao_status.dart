import 'package:montesBelos/features/domain/entities/agencia.dart';
import 'package:montesBelos/features/domain/entities/onibus.dart';

class OnibusConexaoStatus {
  late List<Onibus> frota = [];
  late Agencia origem = Agencia();
  late Agencia destino = Agencia();
  late bool onibusCarregado = false;
  late int quantidadeDeViagem = 0;

  OnibusConexaoStatus(
      {required this.frota,
      required this.origem,
      required this.destino,
      required this.onibusCarregado,
      required this.quantidadeDeViagem});
}
