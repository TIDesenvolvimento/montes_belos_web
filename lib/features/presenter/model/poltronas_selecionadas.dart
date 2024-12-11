import 'package:montesBelos/features/data/models/purchase_request.dart';
import 'package:montesBelos/features/domain/entities/onibus.dart';

class PoltronaSelecionadaComOnibus {
  final Onibus onibusSelecionado;
  final Seat poltronaSelecionada;

  PoltronaSelecionadaComOnibus({
    required this.onibusSelecionado,
    required this.poltronaSelecionada,
  });
}
