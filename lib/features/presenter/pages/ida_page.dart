import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:montesBelos/core/utils/builder/correcao_de_texto.dart';
import 'package:montesBelos/core/utils/constants/configuracao.dart';
import 'package:montesBelos/core/utils/constants/constants.dart';
import 'package:montesBelos/core/utils/constants/cores.dart';
import 'package:montesBelos/core/utils/constants/strings.dart';
import 'package:montesBelos/features/data/models/get_agencias_request.dart';
import 'package:montesBelos/features/data/models/get_viagens_request.dart';
import 'package:montesBelos/features/data/models/onibus_request.dart';
import 'package:montesBelos/features/data/models/purchase_request.dart';
import 'package:montesBelos/features/domain/entities/agencia.dart';
import 'package:montesBelos/features/domain/entities/onibus.dart';
import 'package:montesBelos/features/domain/entities/viagem.dart';
import 'package:montesBelos/features/presenter/components/data_picker.dart';
import 'package:montesBelos/features/presenter/components/dialog_carregamento_widget.dart';
import 'package:montesBelos/features/presenter/components/footer_widget.dart';
import 'package:montesBelos/features/presenter/components/snack_bar_personalizado_widget.dart';
import 'package:montesBelos/features/presenter/model/onibus_conexao_status.dart';
import 'package:montesBelos/features/presenter/pages/volta_page.dart';
import 'package:montesBelos/features/presenter/store/busca_store.dart';
import 'package:montesBelos/features/presenter/store/get_destino_store.dart';
import 'package:montesBelos/features/presenter/store/get_origem_store.dart';
import 'package:montesBelos/features/presenter/store/get_viagem_store.dart';
import 'package:montesBelos/features/presenter/store/onibus_conexao_store.dart';
import 'package:montesBelos/features/presenter/store/onibus_store.dart';
import 'package:montesBelos/features/presenter/store/purchase_request_store.dart';
import 'package:montesBelos/features/presenter/utils/whats_app_helper.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class IdaPage extends StatefulWidget {
  late final PurchaseRequest? purchaseRequest;
  late String? dataIda = '';
  late String? dataVolta = '';
  IdaPage({Key? key}) : super(key: key);

  @override
  _IdaPageState createState() => _IdaPageState();

  IdaPage.fromArgs(dynamic arguments) {
    purchaseRequest = arguments?['purchaseRequest'];
    dataIda = arguments?['dataIda'] ?? '';
    dataVolta = arguments?['dataVolta'] ?? '';
  }

  static void navigate(
      PurchaseRequest purchaseRequest, String dataIda, String dataVolta) {
    Modular.to.navigate(
      '/viagem_ida',
      arguments: {
        'purchaseRequest': purchaseRequest,
        'dataIda': dataIda,
        'dataVolta': dataVolta,
      },
    );
  }
}

class _IdaPageState extends State<IdaPage> {
  final BuscaStore store = Modular.get();
  final ViagemStore viagemStore = Modular.get();
  final OrigemStore getOrigemStore = Modular.get();
  final DestinoStore getDestinoStore = Modular.get();
  final OnibusStore onibusStore = Modular.get();
  final OnibusConexaoStore onibusConexaoStore = Modular.get();

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

  List<Viagem> viagens = [];

  final int currentStep = 1;

  var buscandoNovaData = false;

  var onibus = Onibus();

  List<Seat> seats = [];

  String? idViagemExpandida;
  int? idViagemSelecionada;

  var quantidadeDePoltronasSelecionadas = 0;

  List<Seat> poltronasSelecionadas = [];

  Map<Onibus, List<Seat>> poltronasSelecionadasPorOnibus = {};

  Map<Onibus, double> totalPrecosPorOnibus = {};
  Map<Onibus, double> totalTaxaServicoPorOnibus = {};
  Map<Onibus, double> totalTaxaDeEmbarquePorOnibus = {};

  final ScrollController _scrollController = ScrollController();

  var largura = 0.0;

  ClienteWeb? clienteWeb;

  var quantidadeDeOnibusConexao = 0;

  int onibusVisivel = 0;

  Agencia origem = Agencia();
  Agencia destino = Agencia();
  int contador = 0;
  List<Onibus> frota = [];
  var onibusConexao = Onibus();
  var posicaoDoOnibus = 0;

  var precoDaViagemConexao = 0.0;

  List<List<Seat>> seatsPorOnibus = [];

  Map<int, Map<String, Agencia>> origemDestinoMap = {};

  @override
  void initState() {
    super.initState();

    carregarClienteWeb();
    iniciarPurchaseRequest();
    carregarDatas();

    getOrigemStore.observer(
      onState: (List<Agencia> agencias) {
        setState(() {
          agenciasDeDestino = [];
          this.agenciasDeOrigem = agencias;
        });
      },
    );

    getDestinoStore.observer(
      onState: (List<Agencia> agencias) {
        setState(() {
          agenciasDeOrigem = [];
          this.agenciasDeDestino = agencias;
        });
      },
    );

    viagemStore.observer(
      onState: (List<Viagem> viagens) {
        if (viagens.isNotEmpty) {
          if (buscandoNovaData) {
            DialogDeCarregamento().esconderDialogDeCarregamento(context);
            buscandoNovaData = false;
            _scrollParaBuildViagens();
          }

          this.viagens = viagens;
          setState(() {});
          return;
        }
        DialogDeCarregamento().esconderDialogDeCarregamento(context);
        mostrarSnackBarAtencao('Nenhuma viagem encontrada nessa data');
      },
      onError: (error) {
        this.viagens = [];
        setState(() {});
        DialogDeCarregamento().esconderDialogDeCarregamento(context);
        mostrarSnackBarFalha('Nenhuma viagem encontrada nessa data');
      },
    );

    onibusStore.observer(
      onState: (Onibus onibus) {
        this.onibus = onibus;
        viagens
            .firstWhere((viagem) => viagem.id == idViagemSelecionada)
            .isExpanded = true;
        DialogDeCarregamento().esconderDialogDeCarregamento(context);
        setState(() {});
      },
    );

    onibusConexaoStore.observer(onError: (Exception error) {
      mostrarSnackBarFalha(error.toString());
      DialogDeCarregamento().esconderDialogDeCarregamento(context);
    }, onState: (OnibusConexaoStatus onibusConexaoStatus) {
      if (onibusConexaoStatus.frota.isEmpty) {
        origemDestinoMap[posicaoDoOnibus] = {
          'origem': onibusConexaoStatus.origem,
          'destino': onibusConexaoStatus.destino,
        };
        posicaoDoOnibus++;
        if (posicaoDoOnibus < frota.length) {
          this.onibusConexao = frota[posicaoDoOnibus];
          onibusConexaoStore.getAgenciaDeOrigemPorUrlAmigavel(
              onibusConexao.viagem!.originName!.substring(
                  0, onibusConexao.viagem!.originName!.indexOf(' (')),
              onibusConexao.viagem!.destinationName!.substring(
                  0, onibusConexao.viagem!.destinationName!.indexOf(' (')),
              onibusConexao.viagem!.busCompany!);
          return;
        }

        DialogDeCarregamento().esconderDialogDeCarregamento(context);
        setState(() {});
        return;
      }
      verificarOnibusCarregado(
          onibusConexaoStatus.frota, onibusConexaoStatus.onibusCarregado);
    });
  }

  verificarOnibusCarregado(List<Onibus> frota, bool onibusCarregado) {
    if (onibusCarregado == false) {
      this.frota = frota;
      quantidadeDeOnibusConexao = frota.length;
      this.onibusConexao = frota[posicaoDoOnibus];
      onibusConexaoStore.getAgenciaDeOrigemPorUrlAmigavel(
          onibusConexao.viagem!.originName!
              .substring(0, onibusConexao.viagem!.originName!.indexOf(' (')),
          onibusConexao.viagem!.destinationName!.substring(
              0, onibusConexao.viagem!.destinationName!.indexOf(' (')),
          onibusConexao.viagem!.busCompany!);
    }
  }

  void iniciarPurchaseRequest() async {
    purchaseRequest = (await PurchaseRequestStorage.getPurchaseRequest())!;
  }

  Future<void> carregarClienteWeb() async {
    clienteWeb = (await PurchaseRequestStorage.getClienteWeb())!;
    setState(() {});
  }

  Future<void> carregarDatas() async {
    var dataDeIda = (await PurchaseRequestStorage.getDataIda())!;
    var dataDeVolta = (await PurchaseRequestStorage.getDataVolta())!;

    widget.dataIda = dataDeIda;

    this.dataDeIda = formatarDataDaTelaAnterior(dataDeIda);
    this.dataDeVolta = formatarDataDaTelaAnterior(dataDeVolta);

    origemSelecionada = converterTrechoEmAgencia(purchaseRequest.origin!);
    destinoSelecionado = converterTrechoEmAgencia(purchaseRequest.destination!);
    origemTextEditingController.text =
        '${CorrecaoDeTexto().getNomeDosTrechosCorrigidos(purchaseRequest.origin!.name)} - ${purchaseRequest.origin!.uf!}';
    destinoTextEditingController.text =
        '${CorrecaoDeTexto().getNomeDosTrechosCorrigidos(purchaseRequest.destination!.name)} - ${purchaseRequest.destination!.uf!}';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollParaBuildViagens();
      buscandoNovaData = true;
      DialogDeCarregamento().exibirDialogDeCarregamento(context);
    });

    viagemStore.getViagens(GetViagensRequest(
        urlAmigavelOrigem: purchaseRequest.origin!.urlAmigavel!,
        urlAmigavelDestino: purchaseRequest.destination!.urlAmigavel!,
        data: getData()));
  }

  String formatarDataDaTelaAnterior(String dataOriginal) {
    if (dataOriginal != '') {
      DateTime data = DateTime.parse(dataOriginal);
      String dataFormatada = DateFormat('dd/MM/yyyy').format(data);
      return dataFormatada;
    }
    return '';
  }

  Agencia converterTrechoEmAgencia(Trecho trecho) {
    return Agencia(
      id: trecho.id,
      name: trecho.name,
      uf: trecho.uf,
      urlAmigavel: trecho.urlAmigavel,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white, body: buildComponentsDaTela());
  }

  LayoutBuilder buildComponentsDaTela() {
    largura = MediaQuery.of(context).size.width;
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        controller: _scrollController,
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
                buildHeader(),
                buildAreaDeBusca(),
                buildViagens(),
                Footer()
              ],
            ),
          ),
        ),
      );
    });
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
            GestureDetector(
              onTap: () => navegarParaTelaDeBusca(),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Image.asset(
                  'assets/home/icon_home.png',
                  width: 300,
                  height: 70,
                  fit: BoxFit.fill,
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
                            value: 3,
                            child: Row(
                              children: [
                                Icon(Icons.help_outline,
                                    color: Configuracao().COR_SECUNDARIA),
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

  Future<void> direcionarParaOWhatsapp() async {
    if (!await launchUrl(
        Uri.parse(
            'https://wa.me/5561974033015?text=Ol%C3%A1,%20estou%20vindo%20do%20site%20da%20Expresso%20JK%20e%20quero%20comprar%20passagem.'),
        mode: LaunchMode.externalApplication)) {}
  }

  navegarParaTelaDeComoComprar() {
    Modular.to.navigate('/como_comprar');
  }

  navegarParaTelaDeServicos() {
    Modular.to.navigate('/servicos');
  }

  navegarParaTelaDeNovoCadastro() {
    Modular.to.navigate('/novo_usuario');
  }

  navegarParaTelaDeTelefoneDasAgencias() {
    Modular.to.navigate('/agencias');
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

  navegarParaTelaDeMinhasCompras() {
    Modular.to.navigate('/compras');
  }

  navegarParaTelaDeMeusDados() {
    Modular.to.navigate('/dados');
  }

  Future<void> navegarParaSair() async {
    await PurchaseRequestStorage.clearClienteWeb();
    carregarClienteWeb();
  }

  esconderContainerDeAgenciasExibidas() {
    setState(() {
      agenciasDeOrigem = [];
      agenciasDeDestino = [];
    });
  }

  void _scrollParaBuildViagens() {
    _scrollController.animateTo(
      700.0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Container buildContainerDeViagens() {
    return Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(top: 50),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 3,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            widget.dataIda != '' ? buildCalendario() : Container(),
            Container(
              height: 1,
              color: Color.fromARGB(57, 122, 16, 0),
              margin: const EdgeInsets.only(top: 25),
            ),
            SizedBox(
              height: 10,
            ),
            buildInformacoesDaViagem(),
            Container(
              height: 1,
              color: Color.fromARGB(26, 122, 16, 0),
              margin: const EdgeInsets.only(top: 25),
            ),
            SizedBox(
              height: 10,
            ),
            viagens.isNotEmpty ? buildListaDeViagens() : Container()
          ],
        ));
  }

  buildInformacoesDaViagem() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 5),
                  Text(
                    'Companhia',
                    style: GoogleFonts.inter(
                        color: Colors.grey,
                        fontSize: MediaQuery.of(context).size.width * 0.009,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 12),
                  Text(
                    'Embarque',
                    style: GoogleFonts.inter(
                        color: Colors.grey,
                        fontSize: MediaQuery.of(context).size.width * 0.009,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 12),
                  Text(
                    'Tempo',
                    style: GoogleFonts.inter(
                        color: Colors.grey,
                        fontSize: MediaQuery.of(context).size.width * 0.009,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 12),
                  Text(
                    'Desembarque',
                    style: GoogleFonts.inter(
                        color: Colors.grey,
                        fontSize: MediaQuery.of(context).size.width * 0.009,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 12),
                  Text(
                    'Classe',
                    style: GoogleFonts.inter(
                        color: Colors.grey,
                        fontSize: MediaQuery.of(context).size.width * 0.009,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 12),
                  Text(
                    'Preço',
                    style: GoogleFonts.inter(
                        color: Colors.grey,
                        fontSize: MediaQuery.of(context).size.width * 0.009,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 12),
                  Text(
                    'Selecionar',
                    style: GoogleFonts.inter(
                        color: Colors.grey,
                        fontSize: MediaQuery.of(context).size.width * 0.009,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void navegarParaTelaFaleConosco() {
    Modular.to.navigate('/fale_conosco');
  }

  buildListaDeViagens() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: viagens.map((viagem) => buildItemViagem(viagem)).toList(),
      ),
    );
  }

  Widget buildItemViagem(Viagem viagem) {
    String arrival =
        DateFormat('dd/MM HH:mm').format(DateTime.parse(viagem.arrival!));
    String departure =
        DateFormat('dd/MM HH:mm').format(DateTime.parse(viagem.departure!));

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 120,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Configuracao().COR_SECUNDARIA,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(
                      'assets/home/icon_home.png',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        departure,
                        style: GoogleFonts.inter(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Container(
                          width: 150,
                          child: Text(
                              '${CorrecaoDeTexto().getNomeDosTrechosCorrigidos(purchaseRequest.origin!.name)} - ${purchaseRequest.origin!.uf}',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        calcularDuracaoDaViagem(
                            viagem.departure!, viagem.arrival!),
                        style: GoogleFonts.inter(
                            fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                          height: 10), // Espaçamento entre o texto e a linha
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: CircleAvatar(
                              radius:
                                  5, // Tamanho dos círculos nas extremidades
                              backgroundColor: Colors.grey,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 2,
                              color: Colors.grey, // Cor da linha
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: CircleAvatar(
                              radius:
                                  5, // Tamanho dos círculos nas extremidades
                              backgroundColor: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        arrival,
                        style: GoogleFonts.inter(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      Container(
                        width: 150,
                        child: Text(
                            '${CorrecaoDeTexto().getNomeDosTrechosCorrigidos(purchaseRequest.destination!.name)} - ${purchaseRequest.destination!.uf}',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 12),
                      Text(
                        viagem.service ?? 'CONEXÃO',
                        style: GoogleFonts.inter(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 12),
                      Text(
                        getPrecoDaPassagem(viagem.price!),
                        style: GoogleFonts.inter(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                // Botão selecionar (Remova o Expanded)
                Column(
                  children: [
                    SizedBox(height: 10),
                    SizedBox(
                      width: 170, // Defina a largura desejada
                      height: 45, // Defina a altura desejada
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            if (idViagemSelecionada == viagem.id) {
                              poltronasSelecionadas = [];
                              quantidadeDePoltronasSelecionadas = 0;
                              idViagemSelecionada = null;
                            } else {
                              poltronasSelecionadas = [];
                              quantidadeDePoltronasSelecionadas = 0;
                              idViagemSelecionada = viagem.id;
                              DialogDeCarregamento()
                                  .exibirDialogDeCarregamento(context);
                              this.onibus = Onibus();
                              frota = [];
                              getOnibus(viagem);
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Configuracao().COR_SECUNDARIA,
                          shadowColor: Colors.transparent,
                        ),
                        child: Text(
                          idViagemSelecionada == viagem.id
                              ? "FECHAR"
                              : "SELECIONAR",
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
            if (idViagemSelecionada == viagem.id)
              if (this.onibus.priceInfo != null)
                buildLayoutDoOnibus(viagem)
              else if (frota.isNotEmpty)
                buildLayoutDaFrota(viagem),
            Container(
              height: 1,
              color: Color.fromARGB(26, 122, 16, 0),
              margin: const EdgeInsets.only(top: 25),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLayoutDoOnibus(Viagem viagem) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: this.onibus.busLayout!.decks!.length,
      itemBuilder: (context, indexDeck) {
        return Container(
          height: 400,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Selecione a quantidade de passageiros clicando nas poltronas desejadas:',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildIndicador(
                                'Selecionado', COR_POLTRONA_SELECIONADA),
                            _buildIndicador(
                                'Disponível', COR_POLTRONA_DISPONIVEL),
                            _buildIndicador('Ocupado', COR_POLTRONA_OCUPADA),
                          ],
                        ),
                        SizedBox(height: 20),
                        Expanded(
                          child: Container(
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  image: AssetImage('assets/viagem/onibus.png'),
                                  fit: BoxFit.fill,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.06),
                                child: GridView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 5,
                                    crossAxisSpacing: 10,
                                    mainAxisExtent: 35,
                                    mainAxisSpacing: 10,
                                  ),
                                  itemCount: 75,
                                  itemBuilder: (context, index) {
                                    return carregarOnibus(
                                        this.onibus, index, indexDeck);
                                  },
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 25,
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 25, right: 25, left: 25),
                            child: Text(
                              'POLTRONAS SELECIONADAS',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          // Exibir a lista de poltronas selecionadas
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 25, top: 50, right: 25),
                            child: Column(
                              children: poltronasSelecionadas.map((poltrona) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Assento ${poltrona.id}',
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Configuracao().COR_SECUNDARIA,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 25,
                                      ),
                                      Text(
                                        '${getPrecoDaPassagem(viagem.price!)}',
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Configuracao().COR_SECUNDARIA,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 25, left: 25, bottom: 25),
                            child: Text(
                              'Total: ${getPrecoDaPassagem(poltronasSelecionadas.length * viagem.price!)}',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Configuracao().COR_SECUNDARIA,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 25, left: 25, bottom: 25),
                            child: SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                onPressed: quantidadeDePoltronasSelecionadas > 0
                                    ? () async {
                                        if (quantidadeDePoltronasSelecionadas >
                                            0) {
                                          carregarPoltronasSelecionadas();
                                          await carregarOriginalTravelForward(
                                              buscarViagem());

                                          carregarPurchaseRequestIda();
                                          return;
                                        }
                                        mostrarSnackBarAtencao(
                                            'Nenhuma poltrona seleciona');
                                      }
                                    : null,
                                child: Text(
                                  'PROSSEGUIR',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildLayoutDaFrota(Viagem viagem) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(frota.length, (index) {
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        onibusVisivel = index; // Atualiza o ônibus visível
                      });
                    },
                    child: Container(
                      height: 40,
                      margin: EdgeInsets.symmetric(horizontal: 0),
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: onibusVisivel == index
                            ? Configuracao().COR_PRINCIPAL
                            : Colors.grey[100],
                        borderRadius: BorderRadius.horizontal(
                          left: index == 0 ? Radius.circular(10) : Radius.zero,
                          right: index == frota.length - 1
                              ? Radius.circular(10)
                              : Radius.zero,
                        ),
                        border: Border(
                          left: index == 0
                              ? BorderSide(width: 0.1)
                              : BorderSide.none,
                          right: index == frota.length - 1
                              ? BorderSide(width: 0.1)
                              : BorderSide.none,
                        ),
                      ),
                      child: Text(
                        'Conexão ${index + 1}', // Número da aba
                        style: TextStyle(
                          color: onibusVisivel == index
                              ? Colors.white
                              : const Color.fromARGB(169, 0, 0, 0),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          // Layout do ônibus visível
          Column(
            children: frota.asMap().entries.map((entry) {
              int indexOnibus = entry.key;
              var onibusAtual = entry.value;

              // Exibe apenas o ônibus visível
              if (indexOnibus != onibusVisivel) return SizedBox.shrink();

              return Column(
                children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: onibusAtual.busLayout?.decks?.length ?? 0,
                    itemBuilder: (context, indexDeck) {
                      String arrival = DateFormat('dd/MM HH:mm')
                          .format(DateTime.parse(onibusAtual.viagem!.arrival!));
                      String departure = DateFormat('dd/MM HH:mm').format(
                          DateTime.parse(onibusAtual.viagem!.departure!));

                      return Container(
                        height: 450,
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 0, bottom: 20),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  padding: EdgeInsets.all(20.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 4,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            '${onibusAtual.viagem!.originName} x ${onibusAtual.viagem!.destinationName}',
                                            style: TextStyle(fontSize: 14),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            '${departure} ${arrival}',
                                            style: TextStyle(fontSize: 14),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            getPrecoDaPassagem(
                                                onibusAtual.viagem!.price!),
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 15),
                                      Text(
                                        '${onibusAtual.viagem!.service}',
                                        style: TextStyle(fontSize: 14),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        'Selecione a quantidade de passageiros clicando nas poltronas desejadas:',
                                        style: TextStyle(fontSize: 16),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          _buildIndicador('Selecionado',
                                              COR_POLTRONA_SELECIONADA),
                                          _buildIndicador('Disponível',
                                              COR_POLTRONA_DISPONIVEL),
                                          _buildIndicador(
                                              'Ocupado', COR_POLTRONA_OCUPADA),
                                        ],
                                      ),
                                      SizedBox(height: 20),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.all(10.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/viagem/onibus.png'),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.06,
                                            ),
                                            child: GridView.builder(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              scrollDirection: Axis.horizontal,
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 5,
                                                crossAxisSpacing: 10,
                                                mainAxisExtent: 35,
                                                mainAxisSpacing: 10,
                                              ),
                                              itemCount: 75,
                                              itemBuilder: (context, index) {
                                                return carregarOnibusConexao(
                                                    onibusAtual,
                                                    index,
                                                    indexDeck,
                                                    onibusAtual.viagem!);
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 25),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 4,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 25, right: 25, left: 25),
                                        child: Text(
                                          'POLTRONAS SELECIONADAS',
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              left: 25, top: 50, right: 25),
                                          child: Column(
                                            children:
                                                poltronasSelecionadasPorOnibus
                                                    .entries
                                                    .map((entry) {
                                              var onibus = entry.key;
                                              var poltronas = entry.value;

                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ...poltronas.map((seat) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 8.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Assento ${seat.id}',
                                                            style: GoogleFonts
                                                                .inter(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Configuracao()
                                                                  .COR_SECUNDARIA,
                                                            ),
                                                          ),
                                                          SizedBox(width: 25),
                                                          Text(
                                                            '${getPrecoDaPassagem(onibus.viagem!.price!)}', // Preço da passagem
                                                            style: GoogleFonts
                                                                .inter(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Configuracao()
                                                                  .COR_SECUNDARIA,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }).toList(),
                                                ],
                                              );
                                            }).toList(),
                                          )),
                                      Spacer(),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 25, left: 25, bottom: 10),
                                        child: Text(
                                          'Total: ${getPrecoDaPassagem(calcularPrecoTotal())}',
                                          style: GoogleFonts.inter(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Configuracao().COR_SECUNDARIA,
                                          ),
                                        ),
                                      ),
                                      if (indexOnibus == frota.length - 1)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 25, left: 25, bottom: 25),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 40,
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                if (quantidadeDePoltronasSelecionadas ==
                                                    frota.length) {
                                                  carregarPoltronasSelecionadasFrota();
                                                  carregarPurchaseRequestIdaConexao();
                                                  return;
                                                }
                                                mostrarSnackBarAtencao(
                                                    'Você deve selecionar uma poltrona em cada trecho da conexão');
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.orange,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                              ),
                                              child: Text(
                                                'PROSSEGUIR',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  int quantidadeTotalDePoltronasSelecionadas() {
    return poltronasSelecionadasPorOnibus.values.fold(0, (total, seats) {
      return total + seats.length;
    });
  }

  Viagem buscarViagem() {
    var viagemEscolhida = Viagem();
    for (var viagem in viagens) {
      if (idViagemSelecionada == viagem.id) {
        viagemEscolhida = viagem;
      }
    }
    return viagemEscolhida;
  }

  Widget _buildIndicador(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          SizedBox(width: 5),
          Text(label),
        ],
      ),
    );
  }

  carregarOnibus(Onibus onibus, int indexListView, int indexDeck) {
    for (var seat in onibus.busLayout!.decks![indexDeck].seats!) {
      if (indexListView == seat.index) {
        return MouseRegion(
          cursor: seat.type == Constants.POLTRONA_BLOQUEADA ||
                  seat.type == Constants.POLTRONA_RESERVADA ||
                  seat.type == Constants.POLTRONA_VENDIDA ||
                  seat.type == Constants.POLTRONA_LP ||
                  seat.type == Constants.POLTRONA_SEM_SELECAO
              ? SystemMouseCursors.forbidden
              : SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              setState(() {
                if (seat.type == Constants.POLTRONA_BLOQUEADA ||
                    seat.type == Constants.POLTRONA_RESERVADA ||
                    seat.type == Constants.POLTRONA_VENDIDA ||
                    seat.type == Constants.POLTRONA_LP ||
                    seat.type == Constants.POLTRONA_SEM_SELECAO) {
                  // Não faz nada se a poltrona estiver bloqueada, reservada, vendida, etc.
                  return;
                } else if (seat.type == Constants.POLTRONA_ESCOLHIDA) {
                  retirarSelecaoDePoltrona(onibus, seat.id!);
                } else if (quantidadeDePoltronasSelecionadas <
                    Constants.MAXIMO_DE_POLTRONAS_SELECIONADAS) {
                  selecionarPoltrona(onibus, seat.id!);
                } else {
                  mostrarSnackBarAtencao(onibus__text_maximo_de_poltronas);
                }
              });
            },
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: seat.type == Constants.POLTRONA_BLOQUEADA ||
                          seat.type == Constants.POLTRONA_RESERVADA ||
                          seat.type == Constants.POLTRONA_VENDIDA ||
                          seat.type == Constants.POLTRONA_LP ||
                          seat.type == Constants.POLTRONA_SEM_SELECAO
                      ? COR_POLTRONA_OCUPADA
                      : seat.type == Constants.POLTRONA_ESCOLHIDA
                          ? COR_POLTRONA_SELECIONADA
                          : COR_POLTRONA_DISPONIVEL,
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: Center(
                child: Text(
                  seat.label!,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        );
      }
    }
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(8))),
    );
  }

  carregarOnibusConexao(
      Onibus onibus, int indexListView, int indexDeck, ViagemOriginal viagem) {
    for (var seat in onibus.busLayout!.decks![indexDeck].seats!) {
      if (indexListView == seat.index) {
        return MouseRegion(
          cursor: seat.type == Constants.POLTRONA_BLOQUEADA ||
                  seat.type == Constants.POLTRONA_RESERVADA ||
                  seat.type == Constants.POLTRONA_VENDIDA ||
                  seat.type == Constants.POLTRONA_LP ||
                  seat.type == Constants.POLTRONA_SEM_SELECAO
              ? SystemMouseCursors.forbidden
              : SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              setState(() {
                if (seat.type == Constants.POLTRONA_BLOQUEADA ||
                    seat.type == Constants.POLTRONA_RESERVADA ||
                    seat.type == Constants.POLTRONA_VENDIDA ||
                    seat.type == Constants.POLTRONA_LP ||
                    seat.type == Constants.POLTRONA_SEM_SELECAO) {
                  return;
                } else if (seat.type == Constants.POLTRONA_ESCOLHIDA) {
                  retirarSelecaoDePoltronaFrota(onibus, seat.id!, viagem);
                  poltronasSelecionadasPorOnibus.remove(onibus);
                } else {
                  if (poltronasSelecionadasPorOnibus.containsKey(onibus)) {
                    mostrarSnackBarAtencao(
                        onibus__text_maximo_de_poltronas_conexao);
                  } else {
                    selecionarPoltronaFrota(onibus, seat.id!, viagem);
                    poltronasSelecionadasPorOnibus[onibus] =
                        seat.id! as List<Seat>;
                  }
                }
              });
            },
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: seat.type == Constants.POLTRONA_BLOQUEADA ||
                        seat.type == Constants.POLTRONA_RESERVADA ||
                        seat.type == Constants.POLTRONA_VENDIDA ||
                        seat.type == Constants.POLTRONA_LP ||
                        seat.type == Constants.POLTRONA_SEM_SELECAO
                    ? COR_POLTRONA_OCUPADA
                    : seat.type == Constants.POLTRONA_ESCOLHIDA
                        ? COR_POLTRONA_SELECIONADA
                        : COR_POLTRONA_DISPONIVEL,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Center(
                child: Text(
                  seat.label!,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        );
      }
    }

    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(8))),
    );
  }

  void selecionarPoltrona(Onibus onibus, String id) {
    var posicao = -1;
    for (var seat in onibus.busLayout!.decks![0].seats!) {
      posicao++;
      if (seat.id == id) {
        this.onibus.busLayout!.decks![0].seats![posicao].type =
            Constants.POLTRONA_ESCOLHIDA;

        if (!poltronasSelecionadas.contains(seat)) {
          poltronasSelecionadas.add(seat);
        }

        quantidadeDePoltronasSelecionadas++;

        setState(() {});
        break;
      }
    }
  }

  void retirarSelecaoDePoltrona(Onibus onibus, String id) {
    var posicao = -1;
    for (var seat in onibus.busLayout!.decks![0].seats!) {
      posicao++;
      if (seat.id == id) {
        this.onibus.busLayout!.decks![0].seats![posicao].type =
            Constants.POLTRONA_REMOVIDA;

        poltronasSelecionadas.remove(seat);

        quantidadeDePoltronasSelecionadas--;

        setState(() {});
        break;
      }
    }
  }

  void selecionarPoltronaFrota(
      Onibus onibusSelecionado, String seatId, ViagemOriginal viagem) {
    int indiceOnibus =
        frota.indexWhere((onibus) => onibus == onibusSelecionado);
    if (indiceOnibus == -1) return;

    // ignore: unused_local_variable
    var posicao = -1;
    for (var seat in frota[indiceOnibus].busLayout!.decks![0].seats!) {
      posicao++;
      if (seat.id == seatId) {
        seat.type = Constants.POLTRONA_ESCOLHIDA;

        poltronasSelecionadasPorOnibus.putIfAbsent(onibusSelecionado, () => []);

        if (!poltronasSelecionadasPorOnibus[onibusSelecionado]!
            .any((s) => s.id == seatId)) {
          poltronasSelecionadasPorOnibus[onibusSelecionado]!.add(seat);
          quantidadeDePoltronasSelecionadas++;

          totalPrecosPorOnibus[onibusSelecionado] =
              (totalPrecosPorOnibus[onibusSelecionado] ?? 0) + viagem.price!;

          // Salvar as taxas de serviço e embarque
          totalTaxaServicoPorOnibus[onibusSelecionado] =
              (totalTaxaServicoPorOnibus[onibusSelecionado] ?? 0) +
                  viagem.serviceTax!;
          totalTaxaDeEmbarquePorOnibus[onibusSelecionado] =
              (totalTaxaDeEmbarquePorOnibus[onibusSelecionado] ?? 0) +
                  viagem.boardingFee!;
        }

        setState(() {});
        break;
      }
    }
  }

  double calcularPrecoTotal() {
    return totalPrecosPorOnibus.values.fold(0, (total, preco) => total + preco);
  }

  double calcularTaxaDeServicoTotal() {
    return totalTaxaServicoPorOnibus.values
        .fold(0, (total, preco) => total + preco);
  }

  double calcularTaxaDeEmbarqueTotal() {
    return totalTaxaDeEmbarquePorOnibus.values
        .fold(0, (total, preco) => total + preco);
  }

  void retirarSelecaoDePoltronaFrota(
      Onibus onibusSelecionado, String seatId, ViagemOriginal viagem) {
    int indiceOnibus =
        frota.indexWhere((onibus) => onibus == onibusSelecionado);

    if (indiceOnibus == -1) return;

    // ignore: unused_local_variable
    var posicao = -1;
    for (var seat in frota[indiceOnibus].busLayout!.decks![0].seats!) {
      posicao++;
      if (seat.id == seatId) {
        seat.type = Constants.POLTRONA_REMOVIDA;

        if (poltronasSelecionadasPorOnibus.containsKey(onibusSelecionado)) {
          poltronasSelecionadasPorOnibus[onibusSelecionado]!
              .removeWhere((s) => s.id == seatId);

          totalPrecosPorOnibus[onibusSelecionado] =
              (totalPrecosPorOnibus[onibusSelecionado] ?? 0) - viagem.price!;

          if (poltronasSelecionadasPorOnibus[onibusSelecionado]!.isEmpty) {
            poltronasSelecionadasPorOnibus.remove(onibusSelecionado);
            totalPrecosPorOnibus.remove(onibusSelecionado);
          }

          quantidadeDePoltronasSelecionadas--;

          setState(() {});
        }
        break;
      }
    }
  }

  getOnibus(Viagem viagem) {
    if (viagem.isConexao == true) {
      getLayoutDoOnibusConexao(viagem);
      return;
    }
    getLayoutDoOnibus(viagem);
  }

  getLayoutDoOnibusConexao(Viagem viagem) {
    onibusConexaoStore.getLayoutDoOnibusConexao(OnibusRequest(
      data: viagem.departure,
      idOrigem: viagem.origin,
      idDestino: viagem.destination,
      id: viagem.id,
      idViacao: viagem.busCompany,
    ));
  }

  getLayoutDoOnibus(Viagem viagem) {
    onibusStore.getLayoutDoOnibus(OnibusRequest(
      data: viagem.departure,
      idOrigem: viagem.origin,
      idDestino: viagem.destination,
      id: viagem.id,
      idViacao: viagem.busCompany,
    ));
  }

  String getPrecoDaPassagem(double preco) {
    final NumberFormat formatter = NumberFormat.currency(
      symbol: 'R\$',
      decimalDigits: 2,
      locale: 'pt_BR',
    );
    return formatter.format(preco);
  }

  String calcularDuracaoDaViagem(String departure, String arrival) {
    DateTime departureTime = DateTime.parse(departure);
    DateTime arrivalTime = DateTime.parse(arrival);

    Duration difference = arrivalTime.difference(departureTime);

    String horas = difference.inHours.toString().padLeft(2, '0');
    String minutos = (difference.inMinutes % 60).toString().padLeft(2, '0');

    return '$horas:$minutos';
  }

  buildCalendario() {
    return DatePickerViagem(
      DateTime.parse(widget.dataIda!)
          .subtract(Duration(days: Constants.DIA_ANTERIOR_PARA_MOSTRAR_VIAGEM)),
      locale: 'pt_BR',
      initialSelectedDate: DateTime.parse(widget.dataIda!),
      selectionColor: Configuracao().COR_SECUNDARIA,
      dayTextStyle: TextStyle(
          color: Configuracao().COR_PRINCIPAL,
          fontSize: 16,
          fontFamily: Constants.FONT_DO_APP,
          fontWeight: FontWeight.w600),
      monthTextStyle: TextStyle(
          color: Configuracao().COR_PRINCIPAL,
          fontSize: 16,
          fontFamily: Constants.FONT_DO_APP,
          fontWeight: FontWeight.w600),
      dateTextStyle: TextStyle(
          color: Configuracao().COR_PRINCIPAL,
          fontSize: 16,
          fontFamily: Constants.FONT_DO_APP,
          fontWeight: FontWeight.w600),
      selectedTextColor: Configuracao().COR_SECUNDARIA,
      onDateChange: (data) {
        poltronasSelecionadas = [];
        quantidadeDePoltronasSelecionadas = 0;
        idViagemSelecionada = null;
        carregarData(data);
        getViagens(data);
      },
    );
  }

  Widget _buildStep(String title, int step, int currentStep) {
    bool isActive = step == currentStep;
    bool isCompleted = step < currentStep;

    return Column(
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            color: isActive || isCompleted
                ? Configuracao().COR_SECUNDARIA
                : Configuracao().COR_SECUNDARIA,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w400,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isCompleted
                  ? Configuracao().COR_SECUNDARIA
                  : Configuracao().COR_SECUNDARIA,
              width: 2.0,
            ),
          ),
          child: CircleAvatar(
            radius: 12,
            backgroundColor: isCompleted
                ? Configuracao().COR_SECUNDARIA
                : Colors.transparent,
            child: isActive
                ? CircleAvatar(
                    radius: 10,
                    backgroundColor: Configuracao().COR_SECUNDARIA,
                  )
                : null,
          ),
        ),
      ],
    );
  }

  carregarPoltronasSelecionadas() {
    seats = [];
    for (var seat in this.onibus.busLayout!.decks![0].seats!) {
      if (seat.type == '7') {
        seat.passenger = Passenger();
        seats.add(seat);
      }
    }
  }

  void carregarPoltronasSelecionadasFrota() {
    seatsPorOnibus = [];

    for (var onibus in frota) {
      List<Seat> seatsDoOnibus = [];

      for (var deck in onibus.busLayout!.decks!) {
        for (var seat in deck.seats!) {
          if (seat.type == '7') {
            seat.passenger = Passenger();
            seatsDoOnibus.add(seat);
          }
        }
      }
      seatsPorOnibus.add(seatsDoOnibus);
    }
  }

  void carregarPurchaseRequestIdaConexao() {
    purchaseRequest.forwards = [];

    for (int i = 0; i < frota.length; i++) {
      carregarSentidoDaRotaDeIda(i);
    }
    carregarOriginalTravelForwardConexao();
    purchaseRequest.backwards = [];
    purchaseRequest.quantPoltronasForward = frota.length;
    purchaseRequest.totalPoltronasForward = calcularPrecoTotal();
    purchaseRequest.kreditKard = null;
    purchaseRequest.quantidadeDePoltronasDaConexao =
        seatsPorOnibus.expand((x) => x).toList().length;

    PurchaseRequestStorage.savePurchaseRequest(purchaseRequest);

    if (this.dataDeVolta != "") {
      PurchaseRequestStorage.savePurchaseRequest(purchaseRequest);
      PurchaseRequestStorage.saveDates(
        formatarDataParaOPadraoDoCalendario(dataDeIda),
        formatarDataParaOPadraoDoCalendario(dataDeVolta),
      );
      navegarParaTelaDeSelecaoDeVolta(purchaseRequest);
      return;
    }
    verificarClienteWebLogado();
  }

  void carregarOriginalTravelForwardConexao() {
    var viagemSelecionada = viagens.firstWhere(
      (viagem) => viagem.id == idViagemSelecionada,
    );

    purchaseRequest.originalTravelForward = ViagemOriginal(
      date: viagemSelecionada.date,
      origin: viagemSelecionada.origin,
      originName: viagemSelecionada.originName,
      originUf: viagemSelecionada.originUf,
      destination: viagemSelecionada.destination,
      destinationName: viagemSelecionada.destinationName,
      destinationUf: viagemSelecionada.destinationUf,
      departure: viagemSelecionada.departure,
      arrival: viagemSelecionada.arrival,
      service: viagemSelecionada.service,
      busCompany: viagemSelecionada.busCompany,
      busCompanyName: viagemSelecionada.busCompanyName,
      urlLogo: viagemSelecionada.urlLogo,
      freeSeats: viagemSelecionada.freeSeats,
      price: viagemSelecionada.price,
      toll: viagemSelecionada.toll,
      priceRate: viagemSelecionada.priceRate,
      otherTaxes: viagemSelecionada.otherTaxes,
      discount: viagemSelecionada.discount,
      boardingFee: viagemSelecionada.boardingFee,
      serviceTax: viagemSelecionada.serviceTax,
      busType: viagemSelecionada.busType,
      message: viagemSelecionada.message,
      id: viagemSelecionada.id,
      time: viagemSelecionada.time,
      isConexao: viagemSelecionada.isConexao,
      idConexao: viagemSelecionada.idConexao,
      sequenciaConexao: viagemSelecionada.sequenciaConexao,
      horarioSaidaConexao: viagemSelecionada.horarioSaidaConexao,
      icmsValue: viagemSelecionada.icmsValue,
    );
  }

  void carregarSentidoDaRotaDeIda(int indiceOnibus) {
    var agenciaOrigem = origemDestinoMap[indiceOnibus]?['origem'];
    var agenciaDestino = origemDestinoMap[indiceOnibus]?['destino'];

    if (agenciaOrigem == null || agenciaDestino == null) {
      print(
          'Erro: Agência de origem ou destino não encontrada para o índice $indiceOnibus');
      return;
    }

    var sentidoDaRota = SentidoDaRota(
        origin: Trecho(
          id: agenciaOrigem.id,
          label: agenciaOrigem.urlAmigavel,
          name: agenciaOrigem.name,
          uf: agenciaOrigem.uf,
          urlAmigavel: agenciaOrigem.urlAmigavel,
        ),
        destination: Trecho(
          id: agenciaDestino.id,
          label: agenciaDestino.urlAmigavel,
          name: agenciaDestino.name,
          uf: agenciaDestino.uf,
          urlAmigavel: agenciaDestino.urlAmigavel,
        ),
        travel: frota[indiceOnibus].viagem,
        seats: seatsPorOnibus[indiceOnibus],
        totalPoltronas: calcularPrecoTotal(),
        totalTaxaServico: calcularTaxaDeServicoTotal(),
        totalTaxaEmbarque: calcularTaxaDeEmbarqueTotal(),
        total: calcularPrecoTotal() +
            calcularTaxaDeServicoTotal() +
            calcularTaxaDeEmbarqueTotal());

    validarViagemDeIda(sentidoDaRota);
  }

  void validarViagemDeIda(SentidoDaRota sentidoDaRota) {
    purchaseRequest.forwards?.add(sentidoDaRota);
  }

  carregarOriginalTravelForward(Viagem viagem) {
    purchaseRequest.forwards = [];
    purchaseRequest.backwards = [];
    purchaseRequest.originalTravelForward = ViagemOriginal(
        date: viagem.date,
        origin: viagem.origin,
        originName: viagem.originName,
        originUf: viagem.originUf,
        destination: viagem.destination,
        destinationName: viagem.destinationName,
        destinationUf: viagem.destinationUf,
        departure: viagem.departure,
        arrival: viagem.arrival,
        service: viagem.service,
        busCompany: viagem.busCompany,
        busCompanyName: viagem.busCompanyName,
        urlLogo: viagem.urlLogo,
        freeSeats: viagem.freeSeats,
        price: viagem.price,
        toll: viagem.toll,
        priceRate: viagem.priceRate,
        otherTaxes: viagem.otherTaxes,
        discount: viagem.discount,
        boardingFee: viagem.boardingFee,
        serviceTax: viagem.serviceTax,
        busType: viagem.busType,
        message: viagem.message,
        id: viagem.id,
        time: viagem.time,
        isConexao: viagem.isConexao,
        idConexao: viagem.idConexao,
        sequenciaConexao: viagem.sequenciaConexao,
        horarioSaidaConexao: viagem.horarioSaidaConexao,
        icmsValue: viagem.icmsValue);
  }

  carregarPurchaseRequestIda() {
    purchaseRequest.quantPoltronasForward = quantidadeDePoltronasSelecionadas;
    purchaseRequest.totalPoltronasForward =
        (this.onibus.viagem!.price! * quantidadeDePoltronasSelecionadas);
    purchaseRequest.forwards = <SentidoDaRota>[];
    purchaseRequest.forwards?.add(SentidoDaRota(
        origin: purchaseRequest.origin,
        destination: purchaseRequest.destination,
        travel: purchaseRequest.originalTravelForward,
        seats: seats,
        total:
            (this.onibus.viagem!.price! * quantidadeDePoltronasSelecionadas) +
                (this.onibus.viagem!.serviceTax! *
                    quantidadeDePoltronasSelecionadas) +
                (this.onibus.viagem!.boardingFee! *
                    quantidadeDePoltronasSelecionadas),
        totalPoltronas:
            (this.onibus.viagem!.price! * quantidadeDePoltronasSelecionadas),
        totalTaxaServico: (this.onibus.viagem!.serviceTax! *
            quantidadeDePoltronasSelecionadas),
        totalTaxaEmbarque: (this.onibus.viagem!.boardingFee! *
            quantidadeDePoltronasSelecionadas)));
    purchaseRequest.kreditKard = null;

    PurchaseRequestStorage.savePurchaseRequest(purchaseRequest);

    if (this.dataDeVolta != "") {
      PurchaseRequestStorage.savePurchaseRequest(purchaseRequest);
      PurchaseRequestStorage.saveDates(
        formatarDataParaOPadraoDoCalendario(dataDeIda),
        formatarDataParaOPadraoDoCalendario(dataDeVolta),
      );
      navegarParaTelaDeSelecaoDeVolta(purchaseRequest);
      return;
    }
    verificarClienteWebLogado();
  }

  verificarClienteWebLogado() {
    if (clienteWeb!.id == 0) {
      navegarParaTelaDeLogin();
      return;
    }

    navegarParaTelaDeResumoDeCompra();
  }

  navegarParaTelaDeResumoDeCompra() {
    Modular.to.navigate('/pagamento');
  }

  navegarParaTelaDeLogin() {
    Modular.to.navigate('/login');
  }

  navegarParaTelaDeSelecaoDeVolta(PurchaseRequest purchaseRequest) {
    VoltaPage.navigate(PurchaseRequest(), '', '');
  }

  String formatarDataWpp(String dataString) {
    DateTime data = DateTime.parse(dataString);

    String dataFormatada =
        "${_doisDigitos(data.day)}/${_doisDigitos(data.month)}/${data.year} ${_doisDigitos(data.hour)}:${_doisDigitos(data.minute)}";

    return dataFormatada;
  }

  String _doisDigitos(int numero) {
    return numero.toString().padLeft(2, '0');
  }

  Widget _buildDivider() {
    return Expanded(
      child: Container(
        height: 1,
        color: Configuracao().COR_SECUNDARIA,
        margin: const EdgeInsets.only(top: 25),
      ),
    );
  }

  buildViagens() {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.only(
            top: 50,
            left: largura > 1400 ? 300 : 100,
            right: largura > 1400 ? 300 : 100,
            bottom: 50),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStep('SELECIONAR IDA', 1, currentStep),
                _buildDivider(),
                MouseRegion(
                  cursor: dataDeVolta == ''
                      ? SystemMouseCursors.basic
                      : SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: dataDeVolta == ''
                        ? null
                        : () {
                            navegarParaTelaDeSelecaoDeVolta(purchaseRequest);
                          },
                    child: _buildStep('SELECIONAR VOLTA', 2, currentStep),
                  ),
                ),
                _buildDivider(),
                _buildStep('PAGAMENTO', 3, currentStep),
                _buildDivider(),
                _buildStep('CONFIRMAÇÃO', 4, currentStep),
              ],
            ),
            buildContainerDeViagens(),
          ],
        ),
      ),
    );
  }

  Container buildAreaDeBusca() {
    return Container(
      color: Configuracao().COR_PRINCIPAL,
      width: MediaQuery.of(context).size.width,
      height: 550,
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
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'Compare e escolha sua passagem de ônibus no Montes Belos. É fácil e seguro!',
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
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'Compra garantida e segura | Parcelamento em até 10x | Compre online, sem complicações',
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
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
                          idViagemSelecionada = null;
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

  navegarParaTelaDeFrota() {
    Modular.to.navigate('/frota');
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

  getViagens(DateTime data) async {
    DialogDeCarregamento().exibirDialogDeCarregamento(context);
    buscandoNovaData = true;
    viagemStore.getViagens(GetViagensRequest(
        urlAmigavelOrigem: widget.dataIda == ''
            ? purchaseRequest.destination!.urlAmigavel!
            : purchaseRequest.origin!.urlAmigavel!,
        urlAmigavelDestino: widget.dataIda == ''
            ? purchaseRequest.origin!.urlAmigavel!
            : purchaseRequest.destination!.urlAmigavel!,
        data: '${data.day}-${data.month}-${data.year}'));
  }

  String getData() {
    if (widget.dataIda != '') {
      return widget.dataIda!.substring(8, 10) +
          '-' +
          widget.dataIda!.substring(5, 7) +
          '-' +
          widget.dataIda!.substring(0, 4);
    }
    return widget.dataVolta!.substring(8, 10) +
        '-' +
        widget.dataVolta!.substring(5, 7) +
        '-' +
        widget.dataVolta!.substring(0, 4);
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

  mostrarSnackBarAtencao(String mensagem) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final snackBar = (SnackBarPersonalizado().atencaoSnackBar(mensagem));
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    });
  }

  carregarData(DateTime data) {
    widget.dataIda == '' ? carregarDataVolta(data) : carregarDataIda(data);
  }

  carregarDataIda(DateTime data) {
    widget.dataIda =
        '${data.year}-${formatarData(data.month.toString())}-${formatarData(data.day.toString())}';
  }

  carregarDataVolta(DateTime data) {
    widget.dataVolta =
        '${data.year}-${formatarData(data.month.toString())}-${formatarData(data.day.toString())}';
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

  void navegarParaTelaDeBusca() {
    Modular.to.navigate('/');
  }

  validarOrigemSelecionada() async {
    if (origemSelecionada.id == null) {
      mostrarSnackBarFalha(busca_page__text_origem_obrigatoria);
      return;
    }
    validarDestinoSelecionado();
  }

  validarDestinoSelecionado() async {
    if (destinoSelecionado.id == null) {
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

  Trecho converterAgenciaEmTrecho(Agencia agencia) {
    return Trecho(
      id: agencia.id,
      name: agencia.name,
      uf: agencia.uf,
      urlAmigavel: agencia.urlAmigavel,
      label: agencia.name,
    );
  }

  void navegarTelaDeViagem() {
    carregarPurchaseRequest();
    PurchaseRequestStorage.savePurchaseRequest(purchaseRequest);
    PurchaseRequestStorage.saveDates(
      formatarDataParaOPadraoDoCalendario(dataDeIda),
      formatarDataParaOPadraoDoCalendario(dataDeVolta),
    );

    widget.dataIda = formatarDataParaOPadraoDoCalendario(dataDeIda);
    DialogDeCarregamento().exibirDialogDeCarregamento(context);
    buscandoNovaData = true;

    viagemStore.getViagens(GetViagensRequest(
        urlAmigavelOrigem: purchaseRequest.origin!.urlAmigavel!,
        urlAmigavelDestino: purchaseRequest.destination!.urlAmigavel!,
        data: refazerBuscaDeViagem(
            formatarDataParaOPadraoDoCalendario(dataDeIda))));
  }

  String refazerBuscaDeViagem(String? dataIda) {
    return dataIda!.substring(8, 10) +
        '-' +
        dataIda.substring(5, 7) +
        '-' +
        dataIda.substring(0, 4);
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
