import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:montesBelos/core/utils/constants/configuracao.dart';
import 'package:montesBelos/core/utils/constants/constants.dart';
import 'package:montesBelos/features/data/models/get_telefone_das_agencias_request.dart';
import 'package:montesBelos/features/data/models/get_telefone_das_agencias_response.dart';
import 'package:montesBelos/features/data/models/purchase_request.dart';
import 'package:montesBelos/features/presenter/components/dialog_carregamento_widget.dart';
import 'package:montesBelos/features/presenter/components/footer_widget.dart';
import 'package:montesBelos/features/presenter/components/snack_bar_personalizado_widget.dart';
import 'package:montesBelos/features/presenter/model/usuario.dart';
import 'package:montesBelos/features/presenter/store/get_telefone_das_agencias_store.dart';
import 'package:montesBelos/features/presenter/store/login_store.dart';
import 'package:montesBelos/features/presenter/store/purchase_request_store.dart';
import 'package:montesBelos/features/presenter/utils/whats_app_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class TelefoneDasAgenciasPage extends StatefulWidget {
  @override
  _TelefoneDasAgenciasPageState createState() =>
      _TelefoneDasAgenciasPageState();
}

class _TelefoneDasAgenciasPageState extends State<TelefoneDasAgenciasPage> {
  double largura = 0.0;

  bool _hoverIn1 = false;
  bool _hoverIn2 = false;

  bool _hoverIn4 = false;
  bool _hoverIn5 = false;

  PurchaseRequest? purchaseRequest;

  ClienteWeb? clienteWeb;

  final LoginStore loginStore = Modular.get();
  var emailTextEditingController = TextEditingController(text: '');
  var redefinirEmailTextEditingController = TextEditingController(text: '');
  var senhaTextEditingController = TextEditingController(text: '');

  final GetTelefoneDasAgenciasStore store = Modular.get();

  late Usuario usuario;

  var loginSocialGoogle = false;

  var ufSelecionada = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: buildComponentsDaTela(),
    );
  }

  Future<void> carregarClienteWeb() async {
    clienteWeb = (await PurchaseRequestStorage.getClienteWeb())!;
    setState(() {});
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
                      buildWigetTelefoneDasAgencias(),
                      Expanded(child: Container()),
                      Footer()
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

  @override
  void initState() {
    super.initState();
    carregarPurchaseRequest();
    carregarClienteWeb();

    store.observer(
      onError: (error) {
        mostrarSnackBarFalha(error.toString());
        DialogDeCarregamento().esconderDialogDeCarregamento(context);
      },
      onState: (List<AgenciaData> agencias) {
        DialogDeCarregamento().esconderDialogDeCarregamento(context);
        showAgenciasPopup(context, agencias);
      },
    );
  }

  Future<void> carregarPurchaseRequest() async {
    purchaseRequest = await PurchaseRequestStorage.getPurchaseRequest();
  }

  void navegarParaTelaDeBusca() {
    Modular.to.navigate('/');
  }

  navegarParaTelaDeFrota() {
    Modular.to.navigate('/frota');
  }

  void navegarParaTelaFaleConosco() {
    Modular.to.navigate('/fale_conosco');
  }

  navegarParaTelaDeNovoCadastro() {
    Modular.to.navigate('/novo_usuario');
  }

  navegarParaTelaDeTelefoneDasAgencias() {
    Modular.to.navigate('/agencias');
  }

  Widget buildWigetTelefoneDasAgencias() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'INÍCIO ',
                        style: GoogleFonts.inter(
                            color: Color.fromARGB(255, 1, 162, 231),
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '/ TELEFONE DAS AGÊNCIAS ',
                        style: GoogleFonts.inter(
                            color: Color.fromARGB(255, 0, 69, 99),
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Telefone das Agências',
                    style: GoogleFonts.inter(
                        color: Color.fromARGB(255, 0, 126, 180),
                        fontSize: 30,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'A Montes Belos está presente em mais de 10 estados brasileiros. Clique em um dos estados \rem destaque para ver nossas agências e seus respectivos contatos.',
                    style: GoogleFonts.inter(
                        color: Color.fromARGB(255, 50, 50, 50),
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: largura > 1400 ? 300 : 100,
                          right: largura > 1400 ? 300 : 100,
                        ),
                        child: Container(
                          width: 900,
                          height: 900,
                          child: Stack(
                            children: [
                              Image.asset(
                                'assets/viagem/mapa.png',
                                width: 900,
                                height: 900,
                                fit: BoxFit.contain,
                              ),
                              Positioned(
                                top: 230,
                                left: 400,
                                child: InkWell(
                                  onTap: () {
                                    var uf = 'PA';
                                    ufSelecionada = uf;
                                    DialogDeCarregamento()
                                        .exibirDialogDeCarregamento(context);
                                    store.getTelefoneDasAgencias(
                                        GetTelefoneDasAgenciasRequest(
                                            uf: uf, empId: 49));
                                  },
                                  child: Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 390,
                                left: 350,
                                child: InkWell(
                                  onTap: () {
                                    var uf = 'MT';
                                    ufSelecionada = uf;
                                    DialogDeCarregamento()
                                        .exibirDialogDeCarregamento(context);
                                    store.getTelefoneDasAgencias(
                                        GetTelefoneDasAgenciasRequest(
                                            uf: uf, empId: 49));
                                  },
                                  child: Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 325,
                                left: 500,
                                child: InkWell(
                                  onTap: () {
                                    var uf = 'TO';
                                    ufSelecionada = uf;
                                    DialogDeCarregamento()
                                        .exibirDialogDeCarregamento(context);
                                    store.getTelefoneDasAgencias(
                                        GetTelefoneDasAgenciasRequest(
                                            uf: uf, empId: 49));
                                  },
                                  child: Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 450,
                                left: 470,
                                child: InkWell(
                                  onTap: () {
                                    var uf = 'GO';
                                    ufSelecionada = uf;
                                    DialogDeCarregamento()
                                        .exibirDialogDeCarregamento(context);
                                    store.getTelefoneDasAgencias(
                                        GetTelefoneDasAgenciasRequest(
                                            uf: uf, empId: 49));
                                  },
                                  child: Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 500,
                                right: 300,
                                child: InkWell(
                                  onTap: () {
                                    var uf = 'MG';
                                    ufSelecionada = uf;
                                    DialogDeCarregamento()
                                        .exibirDialogDeCarregamento(context);
                                    store.getTelefoneDasAgencias(
                                        GetTelefoneDasAgenciasRequest(
                                            uf: uf, empId: 49));
                                  },
                                  child: Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 570,
                                right: 380,
                                child: InkWell(
                                  onTap: () {
                                    var uf = 'SP';
                                    ufSelecionada = uf;
                                    DialogDeCarregamento()
                                        .exibirDialogDeCarregamento(context);
                                    store.getTelefoneDasAgencias(
                                        GetTelefoneDasAgenciasRequest(
                                            uf: uf, empId: 49));
                                  },
                                  child: Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 430,
                                left: 505,
                                child: InkWell(
                                  onTap: () {
                                    var uf = 'DF';
                                    ufSelecionada = uf;
                                    DialogDeCarregamento()
                                        .exibirDialogDeCarregamento(context);
                                    store.getTelefoneDasAgencias(
                                        GetTelefoneDasAgenciasRequest(
                                            uf: uf, empId: 49));
                                  },
                                  child: Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 370,
                                right: 250,
                                child: InkWell(
                                  onTap: () {
                                    var uf = 'BA';
                                    ufSelecionada = uf;
                                    DialogDeCarregamento()
                                        .exibirDialogDeCarregamento(context);
                                    store.getTelefoneDasAgencias(
                                        GetTelefoneDasAgenciasRequest(
                                            uf: uf, empId: 49));
                                  },
                                  child: Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 270,
                                right: 250,
                                child: InkWell(
                                  onTap: () {
                                    var uf = 'PI';
                                    ufSelecionada = uf;
                                    DialogDeCarregamento()
                                        .exibirDialogDeCarregamento(context);
                                    store.getTelefoneDasAgencias(
                                        GetTelefoneDasAgenciasRequest(
                                            uf: uf, empId: 49));
                                  },
                                  child: Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 285,
                                right: 150,
                                child: InkWell(
                                  onTap: () {
                                    var uf = 'PE';
                                    ufSelecionada = uf;
                                    DialogDeCarregamento()
                                        .exibirDialogDeCarregamento(context);
                                    store.getTelefoneDasAgencias(
                                        GetTelefoneDasAgenciasRequest(
                                            uf: uf, empId: 49));
                                  },
                                  child: Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 230,
                                right: 195,
                                child: InkWell(
                                  onTap: () {
                                    var uf = 'CE';
                                    ufSelecionada = uf;
                                    DialogDeCarregamento()
                                        .exibirDialogDeCarregamento(context);
                                    store.getTelefoneDasAgencias(
                                        GetTelefoneDasAgenciasRequest(
                                            uf: uf, empId: 49));
                                  },
                                  child: Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 230,
                                right: 310,
                                child: InkWell(
                                  onTap: () {
                                    var uf = 'MA';
                                    ufSelecionada = uf;
                                    DialogDeCarregamento()
                                        .exibirDialogDeCarregamento(context);
                                    store.getTelefoneDasAgencias(
                                        GetTelefoneDasAgenciasRequest(
                                            uf: uf, empId: 49));
                                  },
                                  child: Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  carregarUsuario(User user) {
    usuario = Usuario(
        email: user.email,
        id: user.uid,
        nome: user.displayName,
        tipoDaConta: 1);
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
            bottom: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => navegarParaTelaDeBusca(),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Image.asset(
                  'assets/home/icon_home.png',
                  width: 250,
                  height: 50,
                  fit: BoxFit.contain,
                ),
              ),
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
                  child: GestureDetector(
                    onTap: navegarParaTelaDeBusca,
                    child: Text(
                      "Início",
                      style: GoogleFonts.inter(
                        textStyle: TextStyle(
                          color: _hoverIn1
                              ? Configuracao().COR_SECUNDARIA
                              : Colors.white, // Muda a cor
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
                    onTap: navegarParaTelaFaleConosco,
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
                                GestureDetector(
                                  onTap: navegarParaTelaDeComoComprar,
                                  child: Text("Como Comprar",
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Configuracao().COR_SECUNDARIA,
                                        fontWeight: FontWeight.w600,
                                      )),
                                ),
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
                          borderRadius: BorderRadius.circular(
                              12), // Define as bordas arredondadas
                        ),
                      ).then((value) {
                        if (value == 1) {
                          navegarParaTelaDeTelefoneDasAgencias();
                        }
                        if (value == 2) {
                          navegarParaTelaDeNovoCadastro();
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

  Future<void> direcionarParaOWhatsappParaCompraDePassagem() async {
    if (!await launchUrl(
        Uri.parse(
            'https://wa.me/5563981234000?text=Ol%C3%A1,%20estou%20vindo%20do%20site%20da%20Real%20Maia%20e%20quero%20comprar%20passagem.'),
        mode: LaunchMode.externalApplication)) {}
  }

  navegarParaTelaDeComoComprar() {
    Modular.to.navigate('/como_comprar');
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

  navegarParaTelaDeMinhasCompras() {
    Modular.to.navigate('/compras');
  }

  navegarParaTelaDeMeusDados() {
    Modular.to.navigate('/dados');
  }

  navegarParaTelaDeLogin() {
    Modular.to.navigate('/login');
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

  void showAgenciasPopup(BuildContext context, List<AgenciaData> agencias) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: 800,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Color.fromARGB(255, 0, 126, 180),
                          size: 22,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Agências no $ufSelecionada',
                          style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 69, 99)),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 1,
                      width: MediaQuery.of(context).size.width,
                      color: const Color.fromARGB(169, 158, 158, 158),
                    ),
                    SizedBox(height: 20),
                    Flexible(
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 2,
                        ),
                        itemCount: agencias.length,
                        itemBuilder: (BuildContext context, int index) {
                          final agencia = agencias[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                agencia.nome,
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 0, 126, 180),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4),
                              Text(
                                agencia.fone,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromARGB(255, 0, 126, 180),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                    TextButton(
                      child: Text('Fechar',
                          style: GoogleFonts.inter(fontSize: 14)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}