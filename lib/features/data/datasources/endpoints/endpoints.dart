import 'package:montesBelos/core/utils/constants/constants.dart';
import 'package:montesBelos/features/data/models/get_viagens_request.dart';
import 'package:montesBelos/features/data/models/onibus_request.dart';

class Endpoints {
  static Uri realizarLogin() =>
      Uri.https(Constants.BASE_URL, '/rest/ti/session/logar');

  static Uri getInformacaoDoServidor() =>
      Uri.https(Constants.BASE_URL, '/rest/pbr/server-info');

  static Uri getNovaVersao() => Uri.https(
      Constants.BASE_URL, '/rest/clientes-web/buscar-ultima-versao-app');

  static Uri realizarPagamento() =>
      Uri.https(Constants.BASE_URL, '/rest/pbr/purchase/create');

  static Uri getAgencias(String value) => Uri.https(
      Constants.BASE_URL, '/rest/pbr/search-agency', {'value': value});

  static Uri getParcelas() =>
      Uri.https(Constants.BASE_URL, '/rest/pbr/config-juros-parcelas');

  static Uri getAgenciaPorUrlAmigavel(String urlAmigavel) => Uri.https(
      Constants.BASE_URL,
      '/rest/pbr/agency/friendly-url',
      {'url': urlAmigavel});

  static Uri recuperarSenha() =>
      Uri.https(Constants.BASE_URL, '/rest/clientes-web/password/request');

  static Uri getCompras() =>
      Uri.https(Constants.BASE_URL, '/rest/clientes-web/sales-orders');

  static Uri redefinirSenha() =>
      Uri.https(Constants.BASE_URL, '/rest/clientes-web/password/change');

  static Uri cadastrarUsuario() => Uri.https(
      Constants.BASE_URL, '/rest/clientes-web/cadastrar-novo-usuario');

  static Uri enviarNotificacaoFaleConosco() =>
      Uri.https(Constants.BASE_URL, '/rest/pbr/envia-email-fale-conosco');

  static Uri atualizarClienteWeb() =>
      Uri.https(Constants.BASE_URL, '/rest/clientes-web/update');

  static Uri cancelarVoucher() =>
      Uri.https(Constants.BASE_URL, '/rest/clientes-web/refunds');

  static Uri getLayoutDoOnibus(OnibusRequest onibusRequest) =>
      Uri.https(Constants.BASE_URL, '/rest/pbr/bus-layout', {
        'date': onibusRequest.data,
        'origin': onibusRequest.idOrigem.toString(),
        'destination': onibusRequest.idDestino.toString(),
        'busCompany': onibusRequest.idViacao.toString(),
        'id': onibusRequest.id.toString(),
      });

  static Uri getViagens(GetViagensRequest getViagensRequest) =>
      Uri.https(Constants.BASE_URL, '/rest/pbr/search-travel', {
        'date': getViagensRequest.data,
        'origin': getViagensRequest.urlAmigavelOrigem,
        'destination': getViagensRequest.urlAmigavelDestino
      });

  static Uri getTelefoneDasAgencias(String uf) => Uri.https(Constants.BASE_URL,
      '/rest/pbr/agencia/descricao', {'uf': uf, 'empId': '49'});

  static Uri getLayoutDoOnibusConexao(OnibusRequest onibusRequest) =>
      Uri.https(Constants.BASE_URL, '/rest/pbr/bus-layout-connection', {
        'date': onibusRequest.data,
        'origin': onibusRequest.idOrigem.toString(),
        'destination': onibusRequest.idDestino.toString(),
        'busCompany': onibusRequest.idViacao.toString(),
        'id': onibusRequest.id.toString(),
      });
}
