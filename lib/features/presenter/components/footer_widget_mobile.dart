import 'package:montesBelos/core/utils/constants/configuracao.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class FooterMobile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var largura = MediaQuery.of(context).size.width;
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Configuracao().COR_SECUNDARIA,
      ),
      child: Padding(
        padding: EdgeInsets.only(
            left: largura > 1200 ? 180 : largura * 0.09,
            right: largura > 1200 ? 180 : largura * 0.09,
            top: 50,
            bottom: 50),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Central de Atendimento",
                      style: GoogleFonts.inter(
                        color: Color.fromARGB(174, 255, 255, 255),
                        letterSpacing: .3,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      "Supor: (62) 99931-9109",
                      style: GoogleFonts.inter(
                        color: Color.fromARGB(146, 255, 255, 255),
                        letterSpacing: .3,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      "Precisa de ajuda ou tem uma",
                      style: GoogleFonts.inter(
                        color: Color.fromARGB(146, 255, 255, 255),
                        letterSpacing: .3,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      "pergunta? Contacte-nos em:",
                      style: GoogleFonts.inter(
                        color: Color.fromARGB(146, 255, 255, 255),
                        letterSpacing: .3,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      "sac.montesbelos@gmail.com",
                      style: GoogleFonts.inter(
                        color: Color.fromARGB(146, 255, 255, 255),
                        letterSpacing: .3,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 25),
                    Text(
                      "Menu",
                      style: GoogleFonts.inter(
                        color: Color.fromARGB(174, 255, 255, 255),
                        letterSpacing: .3,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: navegarParaTelaDeBusca,
                        child: Text(
                          "Início",
                          style: GoogleFonts.inter(
                            color: Color.fromARGB(146, 255, 255, 255),
                            letterSpacing: .3,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: navegarParaTelaDeFrota,
                        child: Text(
                          "Nossa Frota",
                          style: GoogleFonts.inter(
                            color: Color.fromARGB(146, 255, 255, 255),
                            letterSpacing: .3,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: navegarParaTelaDeFaleConosco,
                        child: Text(
                          "Fale Conosco",
                          style: GoogleFonts.inter(
                            color: Color.fromARGB(146, 255, 255, 255),
                            letterSpacing: .3,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    Text(
                      "Links úteis",
                      style: GoogleFonts.inter(
                        color: Color.fromARGB(174, 255, 255, 255),
                        letterSpacing: .3,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: navegarParaTelaDeTermosDeUso,
                        child: Text(
                          "Termos de Uso",
                          style: GoogleFonts.inter(
                            color: Color.fromARGB(146, 255, 255, 255),
                            letterSpacing: .3,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: navegarParaTelaDeFaleConosco,
                        child: Text(
                          "Faça sua reclamação",
                          style: GoogleFonts.inter(
                            color: Color.fromARGB(146, 255, 255, 255),
                            letterSpacing: .3,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: navegarParaTelaDePoliticaDePrivacidade,
                        child: Text(
                          "Politica de Privacidade",
                          style: GoogleFonts.inter(
                            color: Color.fromARGB(146, 255, 255, 255),
                            letterSpacing: .3,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    Text(
                      "Nossas parcerias",
                      style: GoogleFonts.inter(
                        color: Color.fromARGB(174, 255, 255, 255),
                        letterSpacing: .3,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15),
                    MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: navegarParaTiSistema,
                          child: Image.asset("assets/home/logo_ti_sistema.png",
                              width: 165),
                        )),
                    MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: navegarParaPassagensBR,
                          child: Image.asset("assets/home/logo_passagensbr.png",
                              width: 165),
                        )),
                  ],
                ),
              ],
            ),
            SizedBox(height: 50),
            Container(
              height: 1,
              width: MediaQuery.of(context).size.width,
              color: Color.fromARGB(48, 255, 255, 255),
            ),
            SizedBox(height: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "©2024 - MONTES BELOS - TODOS DIREITOS RESERVADOS",
                  style: GoogleFonts.inter(
                    color: Color.fromARGB(146, 255, 255, 255),
                    letterSpacing: .3,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.whatsapp,
                      color: Color.fromARGB(146, 255, 255, 255),
                      size: 16,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "(62) 3295-5086",
                      style: GoogleFonts.inter(
                        color: Color.fromARGB(146, 255, 255, 255),
                        letterSpacing: .3,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: navegarParaInstagram,
                        child: Icon(
                          FontAwesomeIcons.instagram,
                          color: Color.fromARGB(174, 255, 255, 255),
                        ),
                      ),
                    ),
                    /*SizedBox(
                      width: 20,
                    ),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: navegarParaFacebook,
                        child: Icon(
                          FontAwesomeIcons.facebook,
                          color: Color.fromARGB(174, 255, 255, 255),
                        ),
                      ),
                    ),*/
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void navegarParaTelaDeTermosDeUso() {
    Modular.to.navigate('/termos_de_uso');
  }

  navegarParaTelaDeFaleConosco() {
    Modular.to.navigate('/fale_conosco');
  }

  void navegarParaTelaDeBusca() {
    Modular.to.navigate('/');
  }

  void navegarParaTelaDePoliticaDePrivacidade() {
    Modular.to.navigate('/politica');
  }

  navegarParaTelaDeServicos() {
    Modular.to.navigate('/servicos');
  }

  navegarParaTelaDeFrota() {
    Modular.to.navigate('/frota');
  }

  Future<void> navegarParaInstagram() async {
    if (!await launchUrl(Uri.parse('https://www.instagram.com/montesBelosofc/'),
        mode: LaunchMode.externalApplication)) {}
  }

  Future<void> navegarParaFacebook() async {
    if (!await launchUrl(
        Uri.parse('https://www.facebook.com/montesBelostransportes/'),
        mode: LaunchMode.externalApplication)) {}
  }

  Future<void> navegarParaTiSistema() async {
    if (!await launchUrl(Uri.parse('https://tisistema.tec.br/'),
        mode: LaunchMode.externalApplication)) {}
  }

  Future<void> navegarParaPassagensBR() async {
    if (!await launchUrl(Uri.parse('https://www.passagensbr.com.br'),
        mode: LaunchMode.externalApplication)) {}
  }

  Future<void> navegarParaArquvivosDasAgencias() async {
    if (!await launchUrl(
      Uri.parse(
          'https://onedrive.live.com/?authkey=%21AHo70azS7%5FRRmUc&id=9EFDF29FD4D39C6D%2133762&cid=9EFDF29FD4D39C6D&parId=root&parQt=sharedby&o=OneUp'),
      mode: LaunchMode.externalApplication,
    )) {}
  }
}
