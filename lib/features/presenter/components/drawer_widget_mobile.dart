import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:montesBelos/core/utils/constants/configuracao.dart';
import 'package:montesBelos/core/utils/constants/constants.dart';
import 'package:montesBelos/features/data/models/purchase_request.dart';
import 'package:montesBelos/features/presenter/store/purchase_request_store.dart';
import 'package:montesBelos/features/presenter/utils/whats_app_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerMobile extends StatelessWidget {
  final ClienteWeb? clienteWeb;

  DrawerMobile({this.clienteWeb});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Configuracao().COR_PRINCIPAL,
      child: Padding(
        padding: const EdgeInsets.only(left: 50, right: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            clienteWeb == null || clienteWeb?.id == 0
                ? SizedBox(
                    height: 45,
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Configuracao().COR_SECUNDARIA,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: GestureDetector(
                        onTapDown: (TapDownDetails details) {
                          if (clienteWeb == null || clienteWeb?.id == 0) {
                            navegarParaTelaDeLogin();
                            return;
                          }
                        },
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person_2_outlined,
                                  color: Colors.white,
                                  size: 22,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  clienteWeb == null || clienteWeb?.id == 0
                                      ? 'Entrar'
                                      : 'Conta',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontFamily: Constants.FONT_DO_APP,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
            SizedBox(height: 50),
            clienteWeb == null || clienteWeb?.id == 0
                ? Container()
                : GestureDetector(
                    onTap: navegarParaTelaDeMeusDados,
                    child: Text(
                      'Meus Dados',
                      style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
            clienteWeb == null || clienteWeb?.id == 0
                ? Container()
                : Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: GestureDetector(
                      onTap: navegarParaTelaDeMinhasCompras,
                      child: Text(
                        'Minhas Compras',
                        style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: navegarParaTelaDeBusca,
              child: Text(
                'Início',
                style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: navegarParaTelaDeFrota,
              child: Text(
                'Nossa Frota',
                style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: navegarParaTelaDeFaleConosco,
              child: Text(
                'Fale Conosco',
                style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: navegarParaTelaDeComoComprar,
              child: Text(
                'Como Comprar',
                style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                WhatsAppHelper().direcionarParaOWhatsapp();
              },
              child: Text(
                'Comprar pelo WhatsApp',
                style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w400),
              ),
            ),
            Spacer(),
            clienteWeb == null || clienteWeb?.id == 0
                ? Container()
                : GestureDetector(
                    onTap: navegarParaSair,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.exit_to_app, color: Colors.white, size: 22),
                        SizedBox(width: 8),
                        Text(
                          'Sair',
                          style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> direcionarParaOWhatsapp() async {
    if (!await launchUrl(
        Uri.parse(
            'https://wa.me/5561974033015?text=Ol%C3%A1,%20estou%20vindo%20do%20site%20da%20Montes%20Belos%20e%20quero%20comprar%20passagem.'),
        mode: LaunchMode.externalApplication)) {}
  }

  navegarParaTelaDeMinhasCompras() {
    Modular.to.navigate('/compras');
  }

  navegarParaTelaDeTelefoneDasAgencias() {
    Modular.to.navigate('/agencias');
  }

  navegarParaTelaDeMeusDados() {
    Modular.to.navigate('/dados');
  }

  void navegarParaSair() {
    PurchaseRequestStorage.clearClienteWeb();
    navegarParaTelaDeLogin();
  }

  navegarParaTelaDeComoComprar() {
    Modular.to.navigate('/como_comprar');
  }

  navegarParaTelaDeFrota() {
    Modular.to.navigate('/frota');
  }

  navegarParaTelaDeLogin() {
    Modular.to.navigate('/login');
  }

  navegarParaTelaDeNovoCadastro() {
    Modular.to.navigate('/novo_usuario');
  }

  navegarParaTelaDeServicos() {
    Modular.to.navigate('/servicos');
  }

  void navegarParaTelaDeBusca() {
    Modular.to.navigate('/');
  }

  navegarParaTelaDeFaleConosco() {
    Modular.to.navigate('/fale_conosco');
  }
}
