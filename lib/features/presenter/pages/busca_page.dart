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
import 'package:montesBelos/features/presenter/components/floating_action_button_widget.dart';
import 'package:montesBelos/features/presenter/components/footer_widget.dart';
import 'package:montesBelos/features/presenter/components/snack_bar_personalizado_widget.dart';
import 'package:montesBelos/features/presenter/pages/ida_page.dart';
import 'package:montesBelos/features/presenter/store/busca_store.dart';
import 'package:montesBelos/features/presenter/store/get_destino_store.dart';
import 'package:montesBelos/features/presenter/store/get_origem_store.dart';
import 'package:montesBelos/features/presenter/store/purchase_request_store.dart';
import 'package:montesBelos/features/presenter/utils/whats_app_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class BuscaPage extends StatefulWidget {
  BuscaPage({Key? key}) : super(key: key);

  @override
  _BuscaPageState createState() => _BuscaPageState();
}

class _BuscaPageState extends State<BuscaPage> {
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

  CarouselController carouselController = CarouselController();

  @override
  void initState() {
    super.initState();

    carregarClienteWeb();
    limparPurchaseRequest();

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

  String getFormattedDate() {
    final DateTime now = DateTime.now();
    final String formattedDate =
        "${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}";
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: buildComponentsDaTela(),
        floatingActionButton: BotaoFlutuante());
  }

  LayoutBuilder buildComponentsDaTela() {
    largura = MediaQuery.of(context).size.width;
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      buildHeader(),
                      buildAreaDeBusca(),
                      buildCarrossel(),
                      buildAreaGratuidade(),
                      buildAreaDeBaixarAplicativo(),
                      buildDestinosMaisProcurados(),
                      Expanded(child: Container()),
                      Footer(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
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
              horizontal: largura > 1400 ? 300 : 100,
              vertical: 30,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 50),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          height: 250,
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
                                            .exibirDialogDeCarregamento(
                                                context);
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
                                              fontWeight: FontWeight.w600,
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
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Expanded(
                      flex: 3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          height: 250,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/home/porto_nacional.jpg'), //
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
                                            .exibirDialogDeCarregamento(
                                                context);
                                        await getOrigemStore
                                            .getAgenciasDeOrigem(
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
                                              fontWeight: FontWeight.w600,
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
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          height: 250,
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
                                            .exibirDialogDeCarregamento(
                                                context);
                                        await getOrigemStore
                                            .getAgenciasDeOrigem(
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
                                              fontWeight: FontWeight.w600,
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
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Expanded(
                      flex: 2,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          height: 250,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/home/gurupi.jpg'), //
                              fit: BoxFit.fill,
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
                                            .exibirDialogDeCarregamento(
                                                context);
                                        await getOrigemStore
                                            .getAgenciasDeOrigem(
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
                                              fontWeight: FontWeight.w600,
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
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: largura > 1400 ? 300 : 100,
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 228, 165, 49),
                    Configuracao().COR_PRINCIPAL,
                  ],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 100, top: 30, bottom: 30),
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Formulário de gratuidades',
                              style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  letterSpacing: .3,
                                  fontSize: 28,
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
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  letterSpacing: .3,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 50, right: 50),
                      child: SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Configuracao().COR_SECUNDARIA,
                            borderRadius: BorderRadius.circular(22),
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
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }

  buildAreaDeBaixarAplicativo() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: largura > 1400 ? 300 : 100,
          vertical: 20,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 228, 165, 49),
                Configuracao().COR_PRINCIPAL,
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 100, top: 50, bottom: 50),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Baixe agora mesmo',
                          style: GoogleFonts.inter(
                            textStyle: TextStyle(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              letterSpacing: .3,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.026,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Agora você pode contar com o nosso aplicativo, disponível para download na App Store e na Play Store! Com uma variedade de recursos, ele auxilia na compra de suas passagens.',
                          textAlign: TextAlign.justify,
                          style: GoogleFonts.inter(
                            textStyle: TextStyle(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              letterSpacing: .3,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.011,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        SizedBox(height: 35),
                        Row(
                          children: [
                            Image.asset(
                              'assets/home/qr_code_home_app.png',
                              width: 80,
                              height: 80,
                            ),
                            SizedBox(width: 35),
                            Expanded(
                              child: Text(
                                'Escaneie o QR Code para baixar agora!',
                                maxLines: 2,
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    letterSpacing: .3,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.013,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 60, top: 65, bottom: 65, left: 60),
                    child: Container(
                      child: Image.asset(
                        'assets/home/arte_aplicativo_home.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double calcularViewportFraction() {
    double largura = MediaQuery.of(context).size.width;
    if (largura > 1200) {
      return 0.25; // 4 itens
    } else if (largura > 800) {
      return 0.33; // 3 itens
    } else if (largura > 600) {
      return 0.5; // 2 itens
    } else {
      return 0.8; // 1 item
    }
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
        padding: EdgeInsets.symmetric(
          horizontal: largura > 1400 ? 300 : 100,
          vertical: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 25),
            Text(
              "Destinos mais procurados",
              style: GoogleFonts.inter(
                textStyle: TextStyle(
                  color: Colors.black,
                  letterSpacing: .3,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 50),
            Stack(
              alignment: Alignment.center,
              children: [
                CarouselSlider(
                  carouselController: carouselController,
                  options: CarouselOptions(
                    height: 400,
                    enableInfiniteScroll: true,
                    enlargeCenterPage: false,
                    autoPlay: true,
                    viewportFraction: calcularViewportFraction(),
                    onPageChanged: (index, reason) {},
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
                                      valorInseridoPeloUsuario:
                                          item['departure']));

                              getDestinoStore.getAgenciasDeDestino(
                                  GetAgenciasRequest(
                                      valorInseridoPeloUsuario:
                                          item['destination']));
                            },
                            child: Column(
                              children: [
                                Container(
                                  width: largura > 1400
                                      ? largura * 0.15
                                      : largura * 0.18,
                                  height: largura > 1400 ? 270 : 230,
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                    child: Image.asset(
                                      item['image']!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: largura > 1400
                                      ? largura * 0.15
                                      : largura * 0.18,
                                  height: 80,
                                  padding: EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 10,
                                  ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.circle,
                                            color:
                                                Configuracao().COR_SECUNDARIA,
                                            size: 10,
                                          ),
                                          Container(
                                            width: 1,
                                            height: 20,
                                            color:
                                                Configuracao().COR_SECUNDARIA,
                                          ),
                                          Icon(
                                            Icons.circle,
                                            color:
                                                Configuracao().COR_SECUNDARIA,
                                            size: 14,
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 25),
                                      Expanded(
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
                Positioned(
                  left: 0,
                  top: 125,
                  child: Transform.translate(
                    offset: Offset(-20, 0), // Move metade para fora
                    child: Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios,
                            size: 16, color: Colors.black),
                        onPressed: () {
                          carouselController.previousPage();
                        },
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 125,
                  child: Transform.translate(
                    offset: Offset(20, 0),
                    child: Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(Icons.arrow_forward_ios,
                            size: 16, color: Colors.black),
                        onPressed: () {
                          carouselController.nextPage();
                        },
                      ),
                    ),
                  ),
                ),
              ],
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
              width: 300,
              height: 70,
              fit: BoxFit.fill,
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
                            value: 3,
                            child: Row(
                              children: [
                                Icon(Icons.help_outline,
                                    color: Configuracao().COR_SECUNDARIA),
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
                                    color: Configuracao().COR_SECUNDARIA),
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
                        if (value == 1) {
                          navegarParaTelaDeTelefoneDasAgencias();
                        }

                        if (value == 3) {
                          navegarParaTelaDeComoComprar();
                        }
                        if (value == 4) {
                          WhatsAppHelper().direcionarParaOWhatsapp();
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

  Future<void> direcionarParaFormularioDeGratuidade() async {
    if (!await launchUrl(
        Uri.parse(
            'https://docs.google.com/forms/d/e/1FAIpQLSceZhB6AVsJZmeG40NfI9RNBHw3ugFlVenTz0p3VhiilHeLKw/viewform'),
        mode: LaunchMode.externalApplication)) {}
  }

  Future<void> direcionarParaOWhatsapp() async {
    if (!await launchUrl(
        Uri.parse(
            'https://wa.me/5561974033015?text=Ol%C3%A1,%20estou%20vindo%20do%20site%20da%20Expresso%20JK%20e%20quero%20comprar%20passagem.'),
        mode: LaunchMode.externalApplication)) {}
  }

  navegarParaTelaDeNovoCadastro() {
    Modular.to.navigate('/novo_usuario');
  }

  navegarParaTelaDeTelefoneDasAgencias() {
    Modular.to.navigate('/agencias');
  }

  navegarParaTelaDeServicos() {
    Modular.to.navigate('/servicos');
  }

  navegarParaTelaDeComoComprar() {
    Modular.to.navigate('/como_comprar');
  }

  navegarParaTelaDeMinhasCompras() {
    Modular.to.navigate('/compras');
  }

  navegarParaTelaDeMeusDados() {
    Modular.to.navigate('/dados');
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
        PopupMenuItem(
          value: 3,
          child: Row(
            children: [
              Icon(Icons.logout, color: Configuracao().COR_PRINCIPAL),
              SizedBox(width: 10),
              Text("Sair",
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
      if (value == 1) {
        navegarParaTelaDeMeusDados();
      }
      if (value == 2) {
        navegarParaTelaDeMinhasCompras();
      }
      if (value == 3) {
        navegarParaSair();
      }
    });
  }

  Future<void> navegarParaSair() async {
    await PurchaseRequestStorage.clearClienteWeb();
    carregarClienteWeb();
  }

  navegarParaTelaDeLogin() {
    Modular.to.navigate('/login');
  }

  Container buildAreaDeBusca() {
    return Container(
      color: Configuracao().COR_PRINCIPAL,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: largura > 1400 ? 300 : 100),
        child: Column(
          children: [
            SizedBox(height: 55),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 400,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildFormulario(),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 150),
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Compare e escolha sua passagem de ônibus com a Montes Belos de forma fácil e segura!',
                            textAlign: TextAlign.justify,
                            style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                color: Colors.white,
                                letterSpacing: .3,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 150),
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'COMPRA 100% SEGURA | COMPRE ONLINE | COMPRE SEM SAIR DE CASA',
                            textAlign: TextAlign.justify,
                            style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                color: const Color.fromARGB(207, 255, 255, 255),
                                letterSpacing: .3,
                                fontSize: 20,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 150),
                            width: double.infinity,
                            child: Image.asset(
                              'assets/home/onibus_home.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 75,
            )
          ],
        ),
      ),
    );
  }

  buildFormulario() {
    final dataIdaTextEditingController =
        TextEditingController(text: dataDeIda == '' ? '' : dataDeIda);
    final dataVoltaTextEditingController =
        TextEditingController(text: dataDeVolta == '' ? '' : dataDeVolta);
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: 450,
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
                          padding: const EdgeInsets.only(
                              left: 30, right: 30, top: 20),
                          child: TextFormField(
                            controller: origemTextEditingController,
                            onTap: () {},
                            onChanged: (value) {
                              if (value.length >= 3) {
                                getOrigemStore.getAgenciasDeOrigem(
                                    GetAgenciasRequest(
                                        valorInseridoPeloUsuario: value));
                              }
                              if (value.length < 3) {
                                setState(() {
                                  agenciasDeOrigem = [];
                                });
                              }
                            },
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
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
                          padding: const EdgeInsets.only(
                              left: 30, right: 30, top: 12),
                          child: TextFormField(
                            controller: destinoTextEditingController,
                            onTap: () {},
                            onChanged: (value) {
                              if (value.length >= 3) {
                                getDestinoStore.getAgenciasDeDestino(
                                    GetAgenciasRequest(
                                        valorInseridoPeloUsuario: value));
                              }
                              if (value.length < 3) {
                                setState(() {
                                  agenciasDeDestino = [];
                                });
                              }
                            },
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
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
                    Positioned(
                      right: 60,
                      top: 78,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: InkWell(
                          onTap: destinoSelecionado.id != null &&
                                  origemSelecionada.id != null
                              ? () {
                                  var temporaria = destinoSelecionado;
                                  destinoSelecionado = origemSelecionada;
                                  origemSelecionada = temporaria;

                                  origemTextEditingController.text =
                                      CorrecaoDeTexto()
                                              .getNomeDosTrechosCorrigidos(
                                                  origemSelecionada.name!) +
                                          ' - ' +
                                          origemSelecionada.uf!;

                                  destinoTextEditingController.text =
                                      CorrecaoDeTexto()
                                              .getNomeDosTrechosCorrigidos(
                                                  destinoSelecionado.name!) +
                                          ' - ' +
                                          destinoSelecionado.uf!;

                                  setState(() {});
                                }
                              : null,
                          child: Container(
                            width: 57,
                            height: 57,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Configuracao().COR_SECUNDARIA,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.swap_vert_outlined,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 30, top: 12),
                      child: Container(
                        width: 190,
                        height: 55,
                        child: TextFormField(
                          controller: dataIdaTextEditingController,
                          onTap: () async {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            mostrarCalendarioDeIda(
                                origemTextEditingController.text,
                                destinoTextEditingController.text);
                          },
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
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
                      padding: const EdgeInsets.only(right: 30, top: 12),
                      child: Container(
                        width: 190,
                        height: 55,
                        child: TextFormField(
                          controller: dataVoltaTextEditingController,
                          onTap: () async {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            mostrarCalendarioDeVolta(
                                origemTextEditingController.text,
                                destinoTextEditingController.text);
                          },
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
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
                  height: 35,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 30, left: 30),
                  child: SizedBox(
                    height: 58,
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
                            fontSize: 16,
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
            agenciasDeOrigem.isNotEmpty
                ? Positioned(
                    top: 94,
                    left: 30,
                    right: 30,
                    child: Material(
                        elevation: 4,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                        child: Container(
                          constraints: BoxConstraints(maxHeight: 200),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: agenciasDeOrigem.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                  CorrecaoDeTexto().getNomeDosTrechosCorrigidos(
                                          agenciasDeOrigem[index].name!) +
                                      ' - ' +
                                      agenciasDeOrigem[index].uf!,
                                ),
                                onTap: () {
                                  setState(() {
                                    origemTextEditingController
                                        .text = CorrecaoDeTexto()
                                            .getNomeDosTrechosCorrigidos(
                                                agenciasDeOrigem[index].name!) +
                                        ' - ' +
                                        agenciasDeOrigem[index].uf!;
                                    origemSelecionada = agenciasDeOrigem[index];
                                    agenciasDeOrigem = [];
                                  });
                                },
                              );
                            },
                          ),
                        )),
                  )
                : Container(),
            if (agenciasDeDestino.isNotEmpty)
              Positioned(
                top: 166,
                left: 30,
                right: 30,
                child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    child: Container(
                      constraints: BoxConstraints(maxHeight: 200),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: agenciasDeDestino.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              CorrecaoDeTexto().getNomeDosTrechosCorrigidos(
                                      agenciasDeDestino[index].name!) +
                                  ' - ' +
                                  agenciasDeDestino[index].uf!,
                            ),
                            onTap: () {
                              setState(() {
                                destinoTextEditingController
                                    .text = CorrecaoDeTexto()
                                        .getNomeDosTrechosCorrigidos(
                                            agenciasDeDestino[index].name!) +
                                    ' - ' +
                                    agenciasDeDestino[index].uf!;
                                destinoSelecionado = agenciasDeDestino[index];
                                agenciasDeDestino = [];
                              });
                            },
                          );
                        },
                      ),
                    )),
              ),
          ],
        ),
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

    IdaPage.navigate(PurchaseRequest(), '', '');
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
