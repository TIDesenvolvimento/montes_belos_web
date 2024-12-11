import 'package:montesBelos/core/utils/constants/constants.dart';

class CorrecaoDeTexto {
  String getNomeDosTrechosCorrigidos(String? texto) {
    if (texto == null || texto.isEmpty) {
      return "";
    }

    var textoCorrigido = texto.toLowerCase().split(RegExp(r'\s+'));

    for (var a = 0; a < textoCorrigido.length; a++) {
      var palavra = textoCorrigido[a];

      if (palavra == Constants.PREPOSICAO_DE ||
          palavra == Constants.PREPOSICAO_DA ||
          palavra == Constants.PREPOSICAO_DAS ||
          palavra == Constants.PREPOSICAO_DOS ||
          palavra == Constants.PREPOSICAO_DO) {
        textoCorrigido[a] = palavra;
      } else {
        textoCorrigido[a] =
            palavra[0].toUpperCase() + palavra.substring(1).toLowerCase();
      }
    }

    return textoCorrigido.join(" ");
  }
}
