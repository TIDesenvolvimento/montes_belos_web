import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:montesBelos/core/utils/builder/correcao_de_texto.dart';
import 'package:montesBelos/core/utils/constants/configuracao.dart';
import 'package:montesBelos/core/utils/constants/constants.dart';
import 'package:montesBelos/core/utils/constants/strings.dart';
import 'package:montesBelos/features/data/models/get_agencias_request.dart';
import 'package:montesBelos/features/data/models/purchase_request.dart';
import 'package:montesBelos/features/domain/entities/agencia.dart';
import 'package:montesBelos/features/presenter/components/dialog_carregamento_widget.dart';
import 'package:montesBelos/features/presenter/components/drawer_widget_mobile.dart';
import 'package:montesBelos/features/presenter/components/floating_action_button_widget_mobile.dart';
import 'package:montesBelos/features/presenter/components/footer_widget_mobile.dart';
import 'package:montesBelos/features/presenter/components/snack_bar_personalizado_widget.dart';
import 'package:montesBelos/features/presenter/pages/ida_page_mobile.dart';
import 'package:montesBelos/features/presenter/store/busca_store.dart';
import 'package:montesBelos/features/presenter/store/get_destino_store.dart';
import 'package:montesBelos/features/presenter/store/get_origem_store.dart';
import 'package:montesBelos/features/presenter/store/purchase_request_store.dart';
import 'package:url_launcher/url_launcher.dart';

class BuscaPageMobile extends StatefulWidget {
  BuscaPageMobile({Key? key}) : super(key: key);

  @override
  _BuscaPageMobileState createState() => _BuscaPageMobileState();
}

class _BuscaPageMobileState extends State<BuscaPageMobile> {
  final BuscaStore store = Modular.get();
  final OrigemStore getOrigemStore = Modular.get();
  final DestinoStore getDestinoStore = Modular.get();

  var origemSelecionada = Agencia();
  var destinoSelecionado = Agencia();

  var dataDeIda = '';
  var dataDeVolta = '';
  var purchaseRequest = PurchaseRequest();

  final origemTextEditingController = TextEditingController();
  final destinoTextEditingController = TextEditingController();

  bool _hoverIn1 = false;
  bool _hoverIn2 = false;

  bool _hoverIn4 = false;
  bool _hoverIn5 = false;

  List<Agencia> agenciasDeOrigem = [];
  List<Agencia> agenciasDeDestino = [];

  var largura = 0.0;

  var clicandoNoCarrossel = false;

  ClienteWeb? clienteWeb;

  @override
  void initState() {
    super.initState();

    carregarClienteWeb();
    limparPurchaseRequest();

    carregarOrigemSelecionada();
    carregarDestinoSelecionado();

    getOrigemStore.observer(
      onState: (List<Agencia> agencias) {
        if (clicandoNoCarrossel) {
          origemSelecionada = agencias.first;
          return;
        }
        setState(() {
          agenciasDeDestino = [];
          this.agenciasDeOrigem = agencias;
        });
      },
    );

    getDestinoStore.observer(
      onState: (List<Agencia> agencias) {
        if (clicandoNoCarrossel) {
          destinoSelecionado = agencias.first;
          clicandoNoCarrossel = false;
          dataDeIda = getFormattedDate();
          DialogDeCarregamento().esconderDialogDeCarregamento(context);
          validarOrigemSelecionada();
          return;
        }
        setState(() {
          agenciasDeOrigem = [];
          this.agenciasDeDestino = agencias;
        });
      },
    );
  }

  Future<void> carregarOrigemSelecionada() async {
    origemSelecionada =
        (await PurchaseRequestStorage.recuperarOrigemSelecionada())!;
    if (origemSelecionada.name != null)
      origemTextEditingController.text = CorrecaoDeTexto()
              .getNomeDosTrechosCorrigidos(origemSelecionada.name!) +
          ' - ' +
          origemSelecionada.uf!;
    setState(() {});
  }

  Future<void> carregarDestinoSelecionado() async {
    destinoSelecionado =
        (await PurchaseRequestStorage.recuperarDestinoSelecionado())!;
    if (destinoSelecionado.name != null)
      destinoTextEditingController.text = CorrecaoDeTexto()
              .getNomeDosTrechosCorrigidos(destinoSelecionado.name!) +
          ' - ' +
          destinoSelecionado.uf!;
    setState(() {});
  }

  String getFormattedDate() {
    final DateTime now = DateTime.now();
    final String formattedDate =
        "${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}";
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer: DrawerMobile(clienteWeb: clienteWeb),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        floatingActionButton: BotaoFlutuanteMobile(),
        appBar: AppBar(
          backgroundColor: Configuracao().COR_PRINCIPAL,
          automaticallyImplyLeading: false,
        ),
        body: buildComponentsDaTela());
  }

  LayoutBuilder buildComponentsDaTela() {
    largura = MediaQuery.of(context).size.width;
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: GestureDetector(
              onTap: () {
                esconderContainerDeAgenciasExibidas();
              },
              child: Column(
                children: [
                  buildAreaDeBusca(),
                  buildCarrossel(),
                  buildAreaGratuidade(),
                  buildAreaDeBaixarAplicativo(),
                  buildDestinosMaisProcurados(),
                  FooterMobile()
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> limparPurchaseRequest() async {
    await PurchaseRequestStorage.clearPurchaseRequest();
  }

  Future<void> carregarClienteWeb() async {
    clienteWeb = (await PurchaseRequestStorage.getClienteWeb())!;
    setState(() {});
  }

  buildDestinosMaisProcurados() {
    return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: largura > 1200 ? 180 : largura * 0.09,
              vertical: 30,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 25,
                ),
                Text(
                  "Principais passagens de ônibus",
                  style: GoogleFonts.inter(
                    textStyle: TextStyle(
                      color: Colors.black,
                      letterSpacing: .3,
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 50),
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 230,
                        width: 800,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/home/xinguara.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 35,
                              ),
                              Text(
                                "Xinguara (PA)",
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    letterSpacing: .3,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                "Saindo de Paraiso do Tocantins (TO)",
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    letterSpacing: .3,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              SizedBox(
                                height: 48,
                                width: 170,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Configuracao().COR_TERCIARIA,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      clicandoNoCarrossel = true;
                                      DialogDeCarregamento()
                                          .exibirDialogDeCarregamento(context);
                                      await getOrigemStore.getAgenciasDeOrigem(
                                          GetAgenciasRequest(
                                              valorInseridoPeloUsuario:
                                                  'Paraiso do Tocantins'));

                                      getDestinoStore.getAgenciasDeDestino(
                                          GetAgenciasRequest(
                                              valorInseridoPeloUsuario:
                                                  'Xinguara'));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'COMPRE AQUI',
                                          style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 230,
                        width: 800,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/home/porto_nacional.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 35,
                              ),
                              Text(
                                "Porto Nacional (TO)",
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    letterSpacing: .3,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                "Saindo de Goiânia (GO)",
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    letterSpacing: .3,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              SizedBox(
                                height: 48,
                                width: 170,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Configuracao().COR_TERCIARIA,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      clicandoNoCarrossel = true;
                                      DialogDeCarregamento()
                                          .exibirDialogDeCarregamento(context);
                                      await getOrigemStore.getAgenciasDeOrigem(
                                          GetAgenciasRequest(
                                              valorInseridoPeloUsuario:
                                                  'Goiânia'));

                                      getDestinoStore.getAgenciasDeDestino(
                                          GetAgenciasRequest(
                                              valorInseridoPeloUsuario:
                                                  'Porto Nacional'));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'COMPRE AQUI',
                                          style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 230,
                        width: 800,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/home/goiania.webp'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 35,
                              ),
                              Text(
                                "Goiânia (GO)",
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    letterSpacing: .3,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                "Saindo de Tucumã (PA)",
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    letterSpacing: .3,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              SizedBox(
                                height: 48,
                                width: 170,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Configuracao().COR_TERCIARIA,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      clicandoNoCarrossel = true;
                                      DialogDeCarregamento()
                                          .exibirDialogDeCarregamento(context);
                                      await getOrigemStore.getAgenciasDeOrigem(
                                          GetAgenciasRequest(
                                              valorInseridoPeloUsuario:
                                                  'Tucumã'));

                                      getDestinoStore.getAgenciasDeDestino(
                                          GetAgenciasRequest(
                                              valorInseridoPeloUsuario:
                                                  'Goiânia'));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'COMPRE AQUI',
                                          style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 230,
                        width: 800,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/home/gurupi.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 35,
                              ),
                              Text(
                                "Gurupi (TO)",
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    letterSpacing: .3,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                "Saindo de Goiânia (GO)",
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    letterSpacing: .3,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              SizedBox(
                                height: 48,
                                width: 170,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Configuracao().COR_TERCIARIA,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      clicandoNoCarrossel = true;
                                      DialogDeCarregamento()
                                          .exibirDialogDeCarregamento(context);
                                      await getOrigemStore.getAgenciasDeOrigem(
                                          GetAgenciasRequest(
                                              valorInseridoPeloUsuario:
                                                  'Goiânia'));

                                      getDestinoStore.getAgenciasDeDestino(
                                          GetAgenciasRequest(
                                              valorInseridoPeloUsuario:
                                                  'Gurupi'));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'COMPRE AQUI',
                                          style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
              ],
            )));
  }

  esconderContainerDeAgenciasExibidas() {
    setState(() {
      agenciasDeOrigem = [];
      agenciasDeDestino = [];
    });
  }

  buildAreaGratuidade() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.only(
            left: largura > 1200 ? 180 : largura * 0.09,
            right: largura > 1200 ? 180 : largura * 0.09,
            top: 50,
            bottom: 50),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 218, 178, 1),
                Configuracao().COR_PRINCIPAL,
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 10, top: 30, bottom: 30, right: 10),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Formulário de gratuidades',
                        style: GoogleFonts.inter(
                          textStyle: TextStyle(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            letterSpacing: .3,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Solicite sua gratuidade!',
                        textAlign: TextAlign.justify,
                        style: GoogleFonts.inter(
                          textStyle: TextStyle(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            letterSpacing: .3,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(),
                        child: SizedBox(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Configuracao().COR_PRINCIPAL,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ElevatedButton(
                              onPressed: () async {
                                direcionarParaFormularioDeGratuidade();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Clique aqui',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> direcionarParaFormularioDeGratuidade() async {
    if (!await launchUrl(
        Uri.parse(
            'https://docs.google.com/forms/d/e/1FAIpQLSceZhB6AVsJZmeG40NfI9RNBHw3ugFlVenTz0p3VhiilHeLKw/viewform'),
        mode: LaunchMode.externalApplication)) {}
  }

  buildAreaDeBaixarAplicativo() {
    double largura = MediaQuery.of(context).size.width;

    return Container(
      width: largura,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: largura > 1200 ? 180 : largura * 0.09,
          vertical: 0,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: 100, // Tamanho mínimo, ajustável conforme necessário
          ),
          child: Container(
            width: largura,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 218, 178, 1),
                  Configuracao().COR_PRINCIPAL,
                ],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, top: 50, bottom: 10, right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Baixe agora mesmo',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          textStyle: TextStyle(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            letterSpacing: .3,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Agora você pode contar com o nosso aplicativo, disponível para download na App Store e na Play Store! Com uma variedade de recursos, ele auxilia na compra de suas passagens.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          textStyle: TextStyle(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            letterSpacing: .3,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(height: 35),
                      Container(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              right: 20, top: 20, bottom: 20, left: 20),
                          child: Image.asset(
                            'assets/home/arte_aplicativo_home.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      SizedBox(height: 35),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Botão para App Store
                          Row(
                            children: [
                              IconButton(
                                icon: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: AssetImage(
                                      'assets/home/icon_apple_store.png'),
                                ),
                                iconSize: 50,
                                onPressed: () async {
                                  const appStoreUrl =
                                      'https://apps.apple.com/us/app/montes-belos/id6453521975';
                                  if (await canLaunchUrl(
                                      Uri.parse(appStoreUrl))) {
                                    await launchUrl(Uri.parse(appStoreUrl));
                                  } else {
                                    throw 'Could not launch $appStoreUrl';
                                  }
                                },
                                tooltip: 'Baixar na App Store',
                                splashRadius: 30,
                              ),
                              SizedBox(width: 20),
                              IconButton(
                                icon: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.white,
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Image.asset(
                                      'assets/home/icon_google_store.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                iconSize: 50,
                                onPressed: () async {
                                  const playStoreUrl =
                                      'https://play.google.com/store/apps/details?id=br.com.tisistema.montesBelos';
                                  if (await canLaunchUrl(
                                      Uri.parse(playStoreUrl))) {
                                    await launchUrl(Uri.parse(playStoreUrl));
                                  } else {
                                    throw 'Could not launch $playStoreUrl';
                                  }
                                },
                                tooltip: 'Baixar na Play Store',
                                splashRadius: 30,
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container buildCarrossel() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(36),
          topRight: Radius.circular(36),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: largura > 1200 ? 180 : largura * 0.09,
          right: largura > 1200 ? 180 : largura * 0.09,
          top: 50,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Destinos mais procurados",
              style: GoogleFonts.inter(
                textStyle: TextStyle(
                  color: Colors.black,
                  letterSpacing: .3,
                  fontSize: 26,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 50),
            CarouselSlider(
              options: CarouselOptions(
                height: 350,
                enableInfiniteScroll: true,
                enlargeCenterPage: false,
                autoPlay: true,
                viewportFraction: 0.9,
              ),
              items: [
                {
                  'image': 'assets/home/goiania.webp',
                  'departure': 'Tucumã (PA)',
                  'destination': 'Goiânia (GO)',
                },
                {
                  'image': 'assets/home/porto_nacional.jpg',
                  'departure': 'Goiânia (GO)',
                  'destination': 'Porto Nacional (TO)',
                },
                {
                  'image': 'assets/home/palmas.webp',
                  'departure': 'Goiânia (GO)',
                  'destination': 'Palmas (TO)',
                },
                {
                  'image': 'assets/home/xinguara.jpg',
                  'departure': 'Paraiso do Tocantins (TO)',
                  'destination': 'Xinguara (PA)',
                },
                {
                  'image': 'assets/home/gurupi.jpg',
                  'departure': 'Goiânia (GO)',
                  'destination': 'Gurupi (TO)',
                }
              ].map((item) {
                return Builder(
                  builder: (BuildContext context) {
                    return MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () async {
                          clicandoNoCarrossel = true;
                          DialogDeCarregamento()
                              .exibirDialogDeCarregamento(context);
                          await getOrigemStore.getAgenciasDeOrigem(
                              GetAgenciasRequest(
                                  valorInseridoPeloUsuario: item['departure']));

                          getDestinoStore.getAgenciasDeDestino(
                              GetAgenciasRequest(
                                  valorInseridoPeloUsuario:
                                      item['destination']));
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 800,
                              height: 250,
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                                child: Image.asset(
                                  item['image']!,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Container(
                              width: 800,
                              height: 80,
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromARGB(54, 0, 0, 0)
                                        .withOpacity(0.08),
                                    spreadRadius: 1,
                                    blurRadius: 20,
                                    offset: Offset(0, 0),
                                  ),
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, top: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.circle,
                                          color: Configuracao().COR_SECUNDARIA,
                                          size: 10,
                                        ),
                                        Container(
                                          width: 1,
                                          height: 20,
                                          color: Configuracao().COR_SECUNDARIA,
                                        ),
                                        Icon(
                                          Icons.circle,
                                          color: Configuracao().COR_SECUNDARIA,
                                          size: 14,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 25),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, top: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['departure']!,
                                            style: GoogleFonts.inter(
                                              textStyle: TextStyle(
                                                color: Colors.black,
                                                letterSpacing: .3,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            item['destination']!,
                                            maxLines: 1,
                                            style: GoogleFonts.inter(
                                              textStyle: TextStyle(
                                                color: Colors.black,
                                                letterSpacing: .3,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Container buildHeader() {
    return Container(
      color: Configuracao().COR_PRINCIPAL,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.only(
            top: 40,
            left: largura > 1400 ? 300 : 100,
            right: largura > 1400 ? 300 : 100,
            bottom: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/home/icon_home.png',
              width: 250,
              height: 50,
              fit: BoxFit.contain,
            ),
            Spacer(),
            Row(
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  onEnter: (_) => setState(() {
                    _hoverIn1 = true;
                  }),
                  onExit: (_) => setState(() {
                    _hoverIn1 = false;
                  }),
                  child: Text(
                    "Início",
                    style: GoogleFonts.inter(
                      textStyle: TextStyle(
                        color: _hoverIn1
                            ? Configuracao().COR_SECUNDARIA
                            : Colors.white, // Muda a cor
                        letterSpacing: .3,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  onEnter: (_) => setState(() {
                    _hoverIn2 = true;
                  }),
                  onExit: (_) => setState(() {
                    _hoverIn2 = false;
                  }),
                  child: GestureDetector(
                    onTap: navegarParaTelaDeFrota,
                    child: Text(
                      "Nossa Frota",
                      style: GoogleFonts.inter(
                        textStyle: TextStyle(
                          color: _hoverIn2
                              ? Configuracao().COR_SECUNDARIA
                              : Colors.white,
                          letterSpacing: .3,
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  onEnter: (_) => setState(() {
                    _hoverIn4 = true;
                  }),
                  onExit: (_) => setState(() {
                    _hoverIn4 = false;
                  }),
                  child: GestureDetector(
                    onTap: navegarParaTelaDeFaleConosco,
                    child: Text(
                      "Fale Conosco",
                      style: GoogleFonts.inter(
                        textStyle: TextStyle(
                          color: _hoverIn4
                              ? Configuracao().COR_SECUNDARIA
                              : Colors.white,
                          letterSpacing: .3,
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  onEnter: (_) => setState(() {
                    _hoverIn5 = true;
                  }),
                  onExit: (_) => setState(() {
                    _hoverIn5 = false;
                  }),
                  child: GestureDetector(
                    onTapDown: (TapDownDetails details) {
                      // Captura a posição para abrir o menu
                      showMenu(
                        context: context,
                        position: RelativeRect.fromLTRB(
                          details.globalPosition.dx - 10,
                          details.globalPosition.dy + 35,
                          details.globalPosition.dx + 20,
                          details.globalPosition.dy + 1,
                        ),
                        items: [
                          PopupMenuItem(
                            value: 2,
                            child: Row(
                              children: [
                                Icon(Icons.app_registration,
                                    color: Configuracao().COR_PRINCIPAL),
                                SizedBox(width: 10),
                                Text("Quero me Cadastrar",
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Configuracao().COR_SECUNDARIA,
                                      fontWeight: FontWeight.w600,
                                    )),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 3,
                            child: Row(
                              children: [
                                Icon(Icons.help_outline,
                                    color: Configuracao().COR_PRINCIPAL),
                                SizedBox(width: 10),
                                Text("Como Comprar",
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Configuracao().COR_SECUNDARIA,
                                      fontWeight: FontWeight.w600,
                                    )),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 4,
                            child: Row(
                              children: [
                                Icon(FontAwesomeIcons.whatsapp,
                                    color: Configuracao().COR_PRINCIPAL),
                                SizedBox(width: 10),
                                Text("Comprar pelo WhatsApp",
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Configuracao().COR_SECUNDARIA,
                                      fontWeight: FontWeight.w600,
                                    )),
                              ],
                            ),
                          ),
                        ],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ).then((value) {
                        if (value == 2) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    navegarParaTelaDeNovoCadastro()),
                          );
                        }
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          "Explorar",
                          style: GoogleFonts.inter(
                            textStyle: TextStyle(
                              color: _hoverIn5
                                  ? Configuracao().COR_SECUNDARIA
                                  : Colors.white,
                              letterSpacing: .3,
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down_outlined,
                          size: 22, // Ícone de seta para baixo
                          color: _hoverIn5
                              ? Configuracao().COR_SECUNDARIA
                              : Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 20),
                SizedBox(
                  height: 38,
                  width: 125,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Configuracao().COR_SECUNDARIA,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: GestureDetector(
                      onTapDown: (TapDownDetails details) {
                        if (clienteWeb == null || clienteWeb?.id == 0) {
                          navegarParaTelaDeLogin();
                        } else {
                          mostrarMenuMinhaConta(details);
                        }
                      },
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                                size: 16,
                              ),
                              SizedBox(width: 8),
                              Text(
                                clienteWeb == null || clienteWeb?.id == 0
                                    ? 'Entrar'
                                    : 'Conta',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
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
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  navegarParaTelaDeNovoCadastro() {
    Modular.to.navigate('/novo_usuario');
  }

  navegarParaTelaDeServicos() {
    Modular.to.navigate('/servicos');
  }

  navegarParaTelaDeFrota() {
    Modular.to.navigate('/frota');
  }

  navegarParaTelaDeFaleConosco() {
    Modular.to.navigate('/fale_conosco');
  }

  mostrarMenuMinhaConta(TapDownDetails details) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        details.globalPosition.dx - 10,
        details.globalPosition.dy + 35,
        details.globalPosition.dx + 20,
        details.globalPosition.dy + 1,
      ),
      items: [
        PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              Icon(Icons.person, color: Configuracao().COR_PRINCIPAL),
              SizedBox(width: 10),
              Text("Meus Dados",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Configuracao().COR_SECUNDARIA,
                    fontWeight: FontWeight.w600,
                  )),
            ],
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Row(
            children: [
              Icon(Icons.shopping_bag, color: Configuracao().COR_PRINCIPAL),
              SizedBox(width: 10),
              Text("Minhas Compras",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Configuracao().COR_SECUNDARIA,
                    fontWeight: FontWeight.w600,
                  )),
            ],
          ),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(12), // Define as bordas arredondadas
      ),
    );
  }

  navegarParaTelaDeLogin() {
    Modular.to.navigate('/login');
  }

  Container buildAreaDeBusca() {
    return Container(
        color: Configuracao().COR_PRINCIPAL,
        width: MediaQuery.of(context).size.width,
        height: 600,
        child: Padding(
          padding: EdgeInsets.only(
            left: 40,
            right: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/home/icon_home.png',
                width: 330,
                height: 110,
                fit: BoxFit.contain,
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 350,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildFormulario(),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  buildFormulario() {
    final dataIdaTextEditingController =
        TextEditingController(text: dataDeIda == '' ? '' : dataDeIda);
    final dataVoltaTextEditingController =
        TextEditingController(text: dataDeVolta == '' ? '' : dataDeVolta);
    return Container(
      width: 305,
      height: 370,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(17)),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 30, right: 30, top: 20),
                        child: TextFormField(
                          controller: origemTextEditingController,
                          onTap: () {
                            Modular.to.pushNamed('/origem',
                                arguments: origemSelecionada);
                          },
                          readOnly: true,
                          onChanged: (value) {},
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontFamily: Constants.FONT_DO_APP,
                              fontWeight: FontWeight.w400),
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.circle_outlined,
                                color: Color.fromARGB(50, 0, 0, 0)),
                            errorStyle: TextStyle(
                                color: Color.fromARGB(50, 0, 0, 0),
                                fontSize: 12,
                                fontFamily: Constants.FONT_DO_APP,
                                fontWeight: FontWeight.w300),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(50, 0, 0, 0),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            fillColor: Color.fromARGB(255, 0, 51, 102),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 23, horizontal: 15),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(50, 0, 0, 0),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(50, 0, 0, 0),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            hintText: busca_page__text_hint_partindo_de,
                            hintStyle: const TextStyle(
                                color: Color.fromARGB(120, 0, 0, 0),
                                fontSize: 16,
                                fontFamily: Constants.FONT_DO_APP,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 30, right: 30, top: 12),
                        child: TextFormField(
                          controller: destinoTextEditingController,
                          onTap: () {
                            Modular.to.pushNamed('/destino',
                                arguments: origemSelecionada);
                          },
                          readOnly: true,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontFamily: Constants.FONT_DO_APP,
                              fontWeight: FontWeight.w400),
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.location_on,
                                color: Color.fromARGB(50, 0, 0, 0)),
                            errorStyle: TextStyle(
                                color: Color.fromARGB(50, 0, 0, 0),
                                fontSize: 12,
                                fontFamily: Constants.FONT_DO_APP,
                                fontWeight: FontWeight.w300),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(50, 0, 0, 0),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            fillColor: Color.fromARGB(255, 0, 51, 102),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 23, horizontal: 15),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(50, 0, 0, 0),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(50, 0, 0, 0),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            hintText: busca_page__text_hint_chegando_em,
                            hintStyle: const TextStyle(
                                color: Color.fromARGB(120, 0, 0, 0),
                                fontSize: 16,
                                fontFamily: Constants.FONT_DO_APP,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 30, top: 10),
                    child: Container(
                      width: 120,
                      height: 50,
                      child: TextFormField(
                        controller: dataIdaTextEditingController,
                        onTap: () async {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          mostrarCalendarioDeIda(
                              origemTextEditingController.text,
                              destinoTextEditingController.text);
                        },
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: Constants.FONT_DO_APP,
                            fontWeight: FontWeight.w400),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.date_range,
                              color: Color.fromARGB(50, 0, 0, 0)),
                          errorStyle: TextStyle(
                              color: Color.fromARGB(50, 0, 0, 0),
                              fontSize: 12,
                              fontFamily: Constants.FONT_DO_APP,
                              fontWeight: FontWeight.w300),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(50, 0, 0, 0),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          fillColor: Color.fromARGB(255, 0, 51, 102),
                          contentPadding: const EdgeInsets.all(0),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(50, 0, 0, 0),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(50, 0, 0, 0),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          hintText: busca_page__text_hint_data_de_ida,
                          hintStyle: const TextStyle(
                              color: Color.fromARGB(120, 0, 0, 0),
                              fontSize: 16,
                              fontFamily: Constants.FONT_DO_APP,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 30, top: 10),
                    child: Container(
                      width: 120,
                      height: 50,
                      child: TextFormField(
                        controller: dataVoltaTextEditingController,
                        onTap: () async {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          mostrarCalendarioDeVolta(
                              origemTextEditingController.text,
                              destinoTextEditingController.text);
                        },
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: Constants.FONT_DO_APP,
                            fontWeight: FontWeight.w400),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.date_range,
                              color: Color.fromARGB(50, 0, 0, 0)),
                          errorStyle: TextStyle(
                              color: Color.fromARGB(50, 0, 0, 0),
                              fontSize: 12,
                              fontFamily: Constants.FONT_DO_APP,
                              fontWeight: FontWeight.w300),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(50, 0, 0, 0),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          fillColor: Color.fromARGB(255, 0, 51, 102),
                          contentPadding: const EdgeInsets.all(5),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(50, 0, 0, 0),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(50, 0, 0, 0),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          hintText: busca_page__text_hint_data_de_volta,
                          hintStyle: const TextStyle(
                              color: Color.fromARGB(120, 0, 0, 0),
                              fontSize: 16,
                              fontFamily: Constants.FONT_DO_APP,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 30, left: 30),
                child: SizedBox(
                  height: 48,
                  width: MediaQuery.of(context).size.width * 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Configuracao().COR_SECUNDARIA,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        validarOrigemSelecionada();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      child: Text(
                        busca_page__botao_buscar_passagens,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: Constants.FONT_DO_APP,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> mostrarDialogNovaVersaoDisponivel(BuildContext context) async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, StepState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(22.0))),
                backgroundColor: Colors.white,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      busca_page__tet_nova_versao_disponivel,
                      maxLines: 5,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                          color: Color.fromARGB(172, 0, 0, 0),
                          fontSize: 14,
                          fontFamily: Constants.FONT_DO_APP,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 38,
                      width: MediaQuery.of(context).size.width * 5,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 0, 166, 158),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            fecharDialog();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          child: Text(
                            novo_usuario_page__text_botao_confirmar,
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: Constants.FONT_DO_APP,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  Future<void> mostrarDialogNovaVersaoObrigatoriaDisponivel(
      BuildContext context) async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, StepState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(22.0))),
                backgroundColor: Colors.white,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      busca_page__tet_nova_versao_obrigatoria_disponivel,
                      maxLines: 5,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                          color: Color.fromARGB(172, 0, 0, 0),
                          fontSize: 14,
                          fontFamily: Constants.FONT_DO_APP,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  mostrarCalendarioDeIda(String origemTextEditingController,
      String destinoTextEditingController) async {
    DateTime? dateTime = await showDatePicker(
      locale: Locale('pt'),
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Configuracao().COR_SECUNDARIA,
            colorScheme: ColorScheme.light(
              primary: Configuracao().COR_SECUNDARIA,
            ),
          ),
          child: child ?? Container(),
        );
      },
    );

    if (dateTime == null) {
      setState(() {
        dataDeIda = '';
      });
      return;
    }

    setState(() {
      dataDeIda = formatarData(dateTime.day.toString()) +
          '/' +
          formatarData(dateTime.month.toString()) +
          '/' +
          dateTime.year.toString();
    });
  }

  mostrarCalendarioDeVolta(String origemTextEditingController,
      String destinoTextEditingController) async {
    DateTime? dateTime = await showDatePicker(
      locale: Locale('pt'),
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Configuracao().COR_SECUNDARIA,
            colorScheme: ColorScheme.light(
              primary: Configuracao().COR_SECUNDARIA,
            ),
          ),
          child: child ?? Container(),
        );
      },
    );

    if (dateTime == null) {
      setState(() {
        dataDeVolta = '';
      });
      return;
    }

    setState(() {
      dataDeVolta = formatarData(dateTime.day.toString()) +
          '/' +
          formatarData(dateTime.month.toString()) +
          '/' +
          dateTime.year.toString();
    });
  }

  String formatarData(String data) {
    if (data.length == Constants.UM) {
      return '0$data';
    }
    return data;
  }

  validarDataIdaVazio() async {
    if (dataDeIda == '') {
      mostrarSnackBarFalha(busca_page__text_data_de_ida_obrigatoria);
      return;
    }
    validarTrechosIguais();
  }

  validarTrechosIguais() {
    if (origemSelecionada.urlAmigavel == destinoSelecionado.urlAmigavel) {
      mostrarSnackBarFalha(busca_page__text_trechos_ida_e_volta_iguais);
      return;
    }
    navegarTelaDeViagem();
  }

  validarOrigemSelecionada() async {
    if (origemSelecionada.id == Constants.NULL ||
        origemSelecionada.id == Constants.ZERO) {
      mostrarSnackBarFalha(busca_page__text_origem_obrigatoria);
      return;
    }
    validarDestinoSelecionado();
  }

  validarDestinoSelecionado() async {
    if (destinoSelecionado.id == Constants.NULL ||
        destinoSelecionado.id == Constants.ZERO) {
      mostrarSnackBarFalha(busca_page__text_destino_obrigatorio);
      return;
    }
    validarDataIdaVazio();
  }

  String formatarDataParaOPadraoDoCalendario(String data) {
    if (data != '') {
      var dia = corrigirData(data.substring(0, 2));
      var mes = corrigirData(data.substring(3, 5));
      var ano = data.substring(6, 10);
      return '$ano-$mes-$dia';
    }
    return '';
  }

  String corrigirData(String data) {
    if (data.length == 1) {
      return '0$data';
    }
    return data;
  }

  fecharDialog() {
    Navigator.of(context).pop();
  }

  carregarPurchaseRequest() {
    this.purchaseRequest.forwards = null;
    this.purchaseRequest.backwards = null;
    this.purchaseRequest.origin = converterAgenciaEmTrecho(origemSelecionada);
    this.purchaseRequest.destination =
        converterAgenciaEmTrecho(destinoSelecionado);
  }

  navegarTelaDeViagem() {
    carregarPurchaseRequest();
    PurchaseRequestStorage.savePurchaseRequest(purchaseRequest);
    PurchaseRequestStorage.saveDates(
        formatarDataParaOPadraoDoCalendario(dataDeIda),
        formatarDataParaOPadraoDoCalendario(dataDeVolta));

    IdaPageMobile.navigate(PurchaseRequest(), '', '');
  }

  Trecho converterAgenciaEmTrecho(Agencia agencia) {
    return Trecho(
      id: agencia.id,
      name: agencia.name,
      uf: agencia.uf,
      urlAmigavel: agencia.urlAmigavel,
      label: agencia.name,
    );
  }

  mostrarSnackBarFalha(String mensagem) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final snackBar = (SnackBarPersonalizado().erroSnackBar(mensagem));
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    });
  }

  mostrarSnackBarSucesso(String mensagem) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final snackBar = (SnackBarPersonalizado().sucessoSnackBar(mensagem));
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    });
  }
}
