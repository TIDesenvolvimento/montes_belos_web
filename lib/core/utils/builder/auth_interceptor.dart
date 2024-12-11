import 'package:montesBelos/core/utils/constants/configuracao.dart';

class AuthInterceptor {
  var tokenGenerico =
      'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJJbnRlZ3JhdG9yIHRva2VuIiwiaW50SWQiOjEsImlzcyI6ImF1dGgwIn0.qSCgYaf2lY2eZbYXuVwaLIKz49-s6R0JzD42d13AM40';
  AuthInterceptor();

  Map<String, String> getHeaders() {
    Map<String, String> headers = {
      'Origin-app': Configuracao().ORIGIN_APP,
      'I-Auth': Configuracao().TOKEN,
    };
    return headers;
  }

  Map<String, String> getHeadersTrecho(int busCompany) {
    Map<String, String> headers = {
      'Origin-app': busCompany == 49
          ? Configuracao().ORIGIN_APP_REAL_MAIA
          : Configuracao().ORIGIN_APP,
      'I-Auth': Configuracao().TOKEN,
    };
    return headers;
  }

  Map<String, String> getHeadersNovaVersao() {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'I-Auth': Configuracao().TOKEN,
    };
    return headers;
  }

  Map<String, String> getHeadersClienteWeb() {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'I-Auth': tokenGenerico,
    };
    return headers;
  }

  Map<String, String> getHeadersAtualizarCliente(String tokenClienteWeb) {
    Map<String, String> headers = {
      'Authorization': 'Bearer $tokenClienteWeb',
      'I-Auth': tokenGenerico,
      'Content-Type': 'application/json'
    };
    return headers;
  }

  Map<String, String> getHeadersMinhasCompras(String tokenClienteWeb) {
    Map<String, String> headers = {
      'Authorization': 'Bearer $tokenClienteWeb',
      'I-Auth': Configuracao().TOKEN,
      'Content-Type': 'application/json'
    };
    return headers;
  }

  Map<String, String> getHeadersPurchaseCreate(String tokenClienteWeb) {
    Map<String, String> headers = {
      'Accept': 'application/json, text/plain, */*',
      'Accept-Language': 'pt-BR,pt;q=0.9',
      'Authorization': 'Bearer $tokenClienteWeb',
      'Content-Type': 'application/json;charset=UTF-8',
      'I-Auth': '${Configuracao().TOKEN}',
    };
    return headers;
  }

  Map<String, String> getHeadersFaleConosco() {
    Map<String, String> headers = {
      'I-Auth': Configuracao().TOKEN,
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };
    return headers;
  }
}
