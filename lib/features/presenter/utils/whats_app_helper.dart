import 'package:url_launcher/url_launcher.dart';

class WhatsAppHelper {
  Future<void> direcionarParaOWhatsapp() async {
    final Uri whatsappUrl = Uri.parse(
        'https://wa.me/6232955086?text=Ol%C3%A1,%20estou%20vindo%20do%20site%20da%20Montes%20Belos%20e%20quero%20comprar%20passagem.');

    if (!await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication)) {
      print('Não foi possível abrir o WhatsApp.');
    }
  }
}
