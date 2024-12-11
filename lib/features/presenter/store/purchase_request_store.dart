import 'dart:convert';

import 'package:montesBelos/features/data/models/purchase_request.dart';
import 'package:montesBelos/features/domain/entities/agencia.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PurchaseRequestStorage {
  static Future<void> savePurchaseRequest(
      PurchaseRequest purchaseRequest) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(purchaseRequest.toJson());
    await prefs.setString('purchaseRequest', jsonString);
  }

  static Future<PurchaseRequest?> getPurchaseRequest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('purchaseRequest');
    if (jsonString != null) {
      Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return PurchaseRequest.fromJson(jsonMap);
    }
    return PurchaseRequest(abrindoTeclado: false);
  }

  static Future<void> saveClienteWeb(ClienteWeb clienteWeb) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(clienteWeb.toJson());
    await prefs.setString('clienteWeb', jsonString);
  }

  static Future<ClienteWeb?> getClienteWeb() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('clienteWeb');
    if (jsonString != null) {
      Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return ClienteWeb.fromJson(jsonMap);
    }
    return ClienteWeb(id: 0);
  }

  static Future<void> clearPurchaseRequest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('purchaseRequest');
  }

  static Future<void> clearClienteWeb() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('clienteWeb');
  }

  static Future<void> saveDates(String? dataIda, String? dataVolta) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('dataIda', dataIda ?? '');
    await prefs.setString('dataVolta', dataVolta ?? '');
  }

  static Future<String?> getDataIda() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('dataIda');
  }

  static Future<String?> getDataVolta() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('dataVolta');
  }

  static Future<void> clearDates() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('dataIda');
    await prefs.remove('dataVolta');
  }

  static Future<void> salvarOrigemSelecionada(Agencia origem) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('origemId', origem.id ?? 0);
    await prefs.setString('origemName', origem.name ?? '');
    await prefs.setString('origemUf', origem.uf ?? '');
    await prefs.setString('origemUrlAmigavel', origem.urlAmigavel ?? '');
  }

  static Future<Agencia?> recuperarOrigemSelecionada() async {
    final prefs = await SharedPreferences.getInstance();

    int? id = prefs.getInt('origemId');
    String? name = prefs.getString('origemName');
    String? uf = prefs.getString('origemUf');
    String? urlAmigavel = prefs.getString('origemUrlAmigavel');

    if (id == null || name == null || uf == null || urlAmigavel == null) {
      return Agencia(
        id: 0,
        name: null,
        uf: null,
        urlAmigavel: '',
      );
    }

    return Agencia(
      id: id,
      name: name,
      uf: uf,
      urlAmigavel: urlAmigavel,
    );
  }

  static Future<void> salvarDestinoSelecionado(Agencia destino) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('destinoId', destino.id ?? 0);
    await prefs.setString('destinoName', destino.name ?? '');
    await prefs.setString('destinomUf', destino.uf ?? '');
    await prefs.setString('destinoUrlAmigavel', destino.urlAmigavel ?? '');
  }

  static Future<Agencia?> recuperarDestinoSelecionado() async {
    final prefs = await SharedPreferences.getInstance();

    int? id = prefs.getInt('destinoId');
    String? name = prefs.getString('destinoName');
    String? uf = prefs.getString('destinomUf');
    String? urlAmigavel = prefs.getString('destinoUrlAmigavel');

    if (id == null || name == null || uf == null || urlAmigavel == null) {
      return Agencia(
        id: 0,
        name: null,
        uf: null,
        urlAmigavel: '',
      );
    }

    return Agencia(
      id: id,
      name: name,
      uf: uf,
      urlAmigavel: urlAmigavel,
    );
  }

  static Future<void> limparOrigemEDestino() async {
    final prefs = await SharedPreferences.getInstance();

    // Removendo as chaves de origem
    await prefs.remove('origemId');
    await prefs.remove('origemName');
    await prefs.remove('origemUf');
    await prefs.remove('origemUrlAmigavel');

    // Removendo as chaves de destino
    await prefs.remove('destinoId');
    await prefs.remove('destinoName');
    await prefs.remove('destinoUf');
    await prefs.remove('destinoUrlAmigavel');
  }
}
