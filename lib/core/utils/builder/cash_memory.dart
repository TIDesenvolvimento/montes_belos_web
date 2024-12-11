import 'package:montesBelos/features/data/models/purchase_request.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CashMemory {
  static salvarTrechoOrigemEmMemoria(Trecho trecho) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt('idOrigem', trecho.id!);
    sharedPreferences.setString('labelOrigem', trecho.label!);
    sharedPreferences.setString('nameOrigem', trecho.name!);
    sharedPreferences.setString('ufOrigem', trecho.uf!);
    sharedPreferences.setString('urlAmigavelOrigem', trecho.urlAmigavel!);
  }

  static salvarTrechoDestinoEmMemoria(Trecho trecho) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt('idDestino', trecho.id!);
    sharedPreferences.setString('labelDestino', trecho.label!);
    sharedPreferences.setString('nameDestino', trecho.name!);
    sharedPreferences.setString('ufDestino', trecho.uf!);
    sharedPreferences.setString('urlAmigavelDestino', trecho.urlAmigavel!);
  }

  static limparPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('idOrigem');
    await preferences.remove('labelOrigem');
    await preferences.remove('nameOrigem');
    await preferences.remove('ufOrigem');
    await preferences.remove('urlAmigavelOrigem');

    await preferences.remove('idDestino');
    await preferences.remove('labelDestino');
    await preferences.remove('nameDestino');
    await preferences.remove('ufDestino');
    await preferences.remove('urlAmigavelDestino');
  }

  static Future<Trecho> getTrechoOrigemEmMemoria() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return Trecho(
      id: sharedPreferences.getInt("idOrigem") ?? 0,
      label: sharedPreferences.getString("labelOrigem") ?? "",
      name: sharedPreferences.getString("nameOrigem") ?? "",
      uf: sharedPreferences.getString("ufOrigem") ?? "",
      urlAmigavel: sharedPreferences.getString("urlAmigavelOrigem") ?? "",
    );
  }

  static Future<Trecho> getTrechoDestinoEmMemoria() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return Trecho(
      id: sharedPreferences.getInt("idDestino") ?? 0,
      label: sharedPreferences.getString("labelDestino") ?? "",
      name: sharedPreferences.getString("nameDestino") ?? "",
      uf: sharedPreferences.getString("ufDestino") ?? "",
      urlAmigavel: sharedPreferences.getString("urlAmigavelDestino") ?? "",
    );
  }
}
