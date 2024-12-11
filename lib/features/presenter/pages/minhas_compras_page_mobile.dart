import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:montesBelos/core/utils/constants/configuracao.dart';
import 'package:montesBelos/core/utils/constants/constants.dart';
import 'package:montesBelos/features/data/models/cancelamento_request.dart';
import 'package:montesBelos/features/data/models/purchase_request.dart';
import 'package:montesBelos/features/domain/entities/get_compras.dart';
import 'package:montesBelos/features/presenter/components/dialog_carregamento_widget.dart';
import 'package:montesBelos/features/presenter/components/drawer_widget_mobile.dart';
import 'package:montesBelos/features/presenter/components/footer_widget_mobile.dart';
import 'package:montesBelos/features/presenter/components/snack_bar_personalizado_widget.dart';
import 'package:montesBelos/features/presenter/store/cancelar_voucher_store.dart';
import 'package:montesBelos/features/presenter/store/get_compras_store.dart';
import 'package:montesBelos/features/presenter/store/purchase_request_store.dart';

class MinhasComprasPageMobile extends StatefulWidget {
  @override
  _MinhasComprasPageMobileState createState() =>
      _MinhasComprasPageMobileState();
}

class _MinhasComprasPageMobileState extends State<MinhasComprasPageMobile> {
  final ComprasStore store = Modular.get();
  final CancelarVoucherStore cancelarVoucherStore = Modular.get();

  double largura = 0.0;

  bool _hoverIn1 = false;
  bool _hoverIn2 = false;

  bool _hoverIn4 = false;
  bool _hoverIn5 = false;

  PurchaseRequest? purchaseRequest;

  ClienteWeb? clienteWeb = ClienteWeb(id: 0);

  bool espandirImagemNovaFrota = false;

  late VoidCallback removerStoreObserver;
  late VoidCallback removerCancelarVoucherStoreObserver;

  var localizadorTextEditingController = TextEditingController(text: '');
  var compras = GetCompras();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        endDrawer: DrawerMobile(clienteWeb: clienteWeb),
        appBar: AppBar(
          backgroundColor: Configuracao().COR_PRINCIPAL,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/home/icon_home.png',
                height: 30,
              ),
            ],
          ),
        ),
        body: buildComponentsDaTela());
  }

  LayoutBuilder buildComponentsDaTela() {
    largura = MediaQuery.of(context).size.width;
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: constraints.maxHeight,
          ),
          child: GestureDetector(
            onTap: () {},
            child: Column(
              children: [buildCabecalho(), buildCompras(), FooterMobile()],
            ),
          ),
        ),
      );
    });
  }

  Future<void> carregarClienteWeb() async {
    clienteWeb = (await PurchaseRequestStorage.getClienteWeb())!;
    getCompras();
  }

  getCompras() {
    store.getCompras(clienteWeb!.tokenClienteWeb!);
    DialogDeCarregamento().exibirDialogDeCarregamento(context);
  }

  @override
  void dispose() {
    removerStoreObserver();
    removerCancelarVoucherStoreObserver();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    carregarClienteWeb();
    limparPurchaseRequest();

    removerStoreObserver = store.observer(
      onState: (GetCompras getCompras) {
        compras = getCompras;
        DialogDeCarregamento().esconderDialogDeCarregamento(context);
        setState(() {});
      },
      onError: (error) {
        DialogDeCarregamento().esconderDialogDeCarregamento(context);
        mostrarSnackBarFalha('Erro ao buscar suas compras');
      },
    );

    removerCancelarVoucherStoreObserver = cancelarVoucherStore.observer(
      onError: (error) {
        DialogDeCarregamento().esconderDialogDeCarregamento(context);
        mostrarSnackBarFalha('Erro ao solicitar cancelamento do voucher');
      },
      onState: (state) {
        DialogDeCarregamento().esconderDialogDeCarregamento(context);
        mostrarSnackBarSucesso(
            'Solicitação de cancelamento efetuada com sucesso');
        getCompras();
      },
    );
  }

  Future<void> limparPurchaseRequest() async {
    await PurchaseRequestStorage.clearPurchaseRequest();
  }

  void navegarParaTelaDeBusca() {
    Modular.to.navigate('/');
  }

  void navegarParaTelaFaleConosco() {
    Modular.to.navigate('/fale_conosco');
  }

  void navegarParaTelaDeServicos() {
    Modular.to.navigate('/servicos');
  }

  navegarParaTelaDeNovoCadastro() {
    Modular.to.navigate('/novo_usuario');
  }

  navegarParaTelaDeComoComprar() {
    Modular.to.navigate('/como_comprar');
  }

  Container buildCabecalho() {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 15),
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
                      color: Configuracao().COR_SECUNDARIA,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  '/ MINHAS COMPRAS ',
                  style: GoogleFonts.inter(
                      color: Configuracao().COR_PRINCIPAL,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            SizedBox(height: 15),
            Text(
              'Minhas Compras',
              style: GoogleFonts.inter(
                  color: Configuracao().COR_PRINCIPAL,
                  fontSize: 30,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
    );
  }

  void mostrarPopupSolicitarCancelamento() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Solicitar Cancelamento',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Para solicitar o cancelamento, informe o código localizador, que pode ser encontrado nos detalhes do seu pedido.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                      fontSize: 14, color: Configuracao().COR_SECUNDARIA),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: localizadorTextEditingController,
                  decoration: InputDecoration(
                    hintText: 'Código localizador',
                    hintStyle: TextStyle(
                      color: const Color.fromARGB(179, 158, 158, 158),
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                          color: const Color.fromARGB(179, 158, 158, 158)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Configuracao().COR_PRINCIPAL,
                      ),
                    ),
                  ),
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 56, 56, 56),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Solicitar', style: GoogleFonts.inter(fontSize: 14)),
              onPressed: () {
                if (localizadorTextEditingController.text.isNotEmpty) {
                  Navigator.of(context).pop();
                  DialogDeCarregamento().exibirDialogDeCarregamento(context);
                  cancelarVoucherStore.cancelarVoucher(CancelamentoRequest(
                      localizador:
                          int.parse(localizadorTextEditingController.text)));
                }
              },
            ),
            TextButton(
              child: Text('Fechar', style: GoogleFonts.inter(fontSize: 14)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Container buildCompras() {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  mostrarPopupSolicitarCancelamento();
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 15),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Solicitar cancelamento',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Configuracao().COR_PRINCIPAL,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 0,
                left: 10,
                right: 10,
                bottom: 40,
              ),
              child: Column(
                children: List.generate(compras.compras?.length ?? 0, (index) {
                  Compra compra = compras.compras![index];
                  bool isExpanded = compra.expanded ?? false;

                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            compra.expanded = !isExpanded;
                          });
                        },
                        child: Container(
                          height: 160,
                          width: 400,
                          decoration: BoxDecoration(
                            color: Configuracao().COR_PRINCIPAL,
                            borderRadius: BorderRadius.only(
                                bottomLeft: isExpanded == false
                                    ? Radius.circular(20)
                                    : Radius.circular(0),
                                bottomRight: isExpanded == false
                                    ? Radius.circular(20)
                                    : Radius.circular(0),
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)),
                            border: Border.all(
                              color: Configuracao().COR_PRINCIPAL,
                            ),
                          ),
                          padding: EdgeInsets.all(16),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 25, right: 25),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'N° do pedido: ${compra.id}',
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Data: ${compra.dataCriacao}',
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Valor: ${formatCurrency(compra.valor ?? 0)}',
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  width: 165,
                                  height: 38,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      setState(() {
                                        compra.expanded = !isExpanded;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            15), // Arredonda os cantos
                                      ),
                                    ),
                                    child: Text(
                                      'Ver Detalhes',
                                      style: GoogleFonts.inter(
                                        color: Configuracao().COR_SECUNDARIA,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (isExpanded) ...[
                        Column(
                          children: compra.detalhesDaCompra?.map((detalhe) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFFFFFF),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                      ),
                                      border: Border.all(
                                          color:
                                              Color.fromARGB(52, 57, 114, 212)),
                                    ),
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Localizador: ${detalhe.id ?? 'N/A'}',
                                              style: GoogleFonts.inter(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Configuracao()
                                                    .COR_SECUNDARIA,
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.copy,
                                                  size: 14,
                                                  color: Color.fromARGB(
                                                      255, 0, 126, 180)),
                                              onPressed: () {
                                                String textToCopy =
                                                    detalhe.id.toString();
                                                Clipboard.setData(ClipboardData(
                                                    text: textToCopy));
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'Copiado para a área de transferência!'),
                                                    duration:
                                                        Duration(seconds: 2),
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                        Text(
                                          'Vouncher: ${detalhe.voucherId ?? 'N/A'}',
                                          style: GoogleFonts.inter(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Configuracao()
                                                  .COR_SECUNDARIA),
                                        ),
                                        Text(
                                          'Origem: ${detalhe.cidadeOrigem ?? ''} (${detalhe.ufOrigem ?? ''})',
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color:
                                                Configuracao().COR_SECUNDARIA,
                                          ),
                                        ),
                                        Text(
                                          'Destino: ${detalhe.cidadeDestino ?? ''} (${detalhe.ufDestino ?? ''})',
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color:
                                                Configuracao().COR_SECUNDARIA,
                                          ),
                                        ),
                                        Text(
                                          'Data Saída: ${detalhe.dataSaida ?? 'N/A'}',
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color:
                                                Configuracao().COR_SECUNDARIA,
                                          ),
                                        ),
                                        Text(
                                          'Data Chegada: ${detalhe.dataChegada ?? 'N/A'}',
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color:
                                                Configuracao().COR_SECUNDARIA,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList() ??
                              [],
                        ),
                        SizedBox(height: 25),
                      ],
                      SizedBox(height: 20),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatCurrency(double value) {
    final NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    );
    return currencyFormatter.format(value);
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
                  child: Text(
                    "Nossa Frota",
                    style: GoogleFonts.inter(
                      textStyle: TextStyle(
                        color: _hoverIn2
                            ? Configuracao().COR_SECUNDARIA
                            : Colors.white,
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
