import 'package:flutter_triple/flutter_triple.dart';
import 'package:montesBelos/core/utils/builder/cash_memory.dart';
import 'package:montesBelos/features/data/models/purchase_request.dart';
import 'package:montesBelos/features/domain/entities/busca_status.dart';

class BuscaStore extends NotifierStore<Exception, BuscaStatus> {
  BuscaStore() : super(BuscaStatus(trechoIda: Trecho(), trechoVolta: Trecho()));

  getTrechos() async {
    final trechoIda = await CashMemory.getTrechoOrigemEmMemoria();
    final trechoVolta = await CashMemory.getTrechoDestinoEmMemoria();

    update(BuscaStatus(trechoIda: trechoIda, trechoVolta: trechoVolta));
  }
}
