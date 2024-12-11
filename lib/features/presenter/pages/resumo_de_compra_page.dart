import 'dart:async';
import 'dart:convert';
import 'dart:js' as js;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_multi_formatter/formatters/credit_card_number_input_formatter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:montesBelos/core/utils/builder/correcao_de_texto.dart';
import 'package:montesBelos/core/utils/constants/configuracao.dart';
import 'package:montesBelos/core/utils/constants/constants.dart';
import 'package:montesBelos/core/utils/constants/strings.dart';
import 'package:montesBelos/features/data/models/purchase_request.dart';
import 'package:montesBelos/features/domain/entities/pagamento_pix_status.dart';
import 'package:montesBelos/features/domain/entities/parcela_status.dart';
import 'package:montesBelos/features/presenter/components/dialog_carregamento_widget.dart';
import 'package:montesBelos/features/presenter/components/footer_widget.dart';
import 'package:montesBelos/features/presenter/components/snack_bar_personalizado_widget.dart';
import 'package:montesBelos/features/presenter/store/get_parcelas_store.dart';
import 'package:montesBelos/features/presenter/store/pagamento_pix_store.dart';
import 'package:montesBelos/features/presenter/store/pagamento_store.dart';
import 'package:montesBelos/features/presenter/store/purchase_request_store.dart';
import 'package:montesBelos/features/presenter/utils/whats_app_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class ResumoDeCompraPage extends StatefulWidget {
  @override
  _ResumoDeCompraPageState createState() => _ResumoDeCompraPageState();
}

class _ResumoDeCompraPageState extends State<ResumoDeCompraPage> {
  double largura = 0.0;

  bool _hoverIn1 = false;
  bool _hoverIn2 = false;

  bool _hoverIn4 = false;
  bool _hoverIn5 = false;

  List<TextEditingController> nomeControllersIda = [];
  List<TextEditingController> rgControllersIda = [];
  List<TextEditingController> telefoneControllersIda = [];
  List<TextEditingController> orgaoEmissorControllersIda = [];

  List<TextEditingController> nomeControllersVolta = [];
  List<TextEditingController> rgControllersVolta = [];
  List<TextEditingController> telefoneControllersVolta = [];
  List<TextEditingController> orgaoEmissorControllersVolta = [];

  final TextEditingController numeroDoCartaoTextEditingController =
      TextEditingController();
  final TextEditingController validadeDoCartaoTextEditingController =
      TextEditingController();
  final TextEditingController cvvDoCartaoTextEditingController =
      TextEditingController();
  final TextEditingController titularDoCartaoTextEditingController =
      TextEditingController();

  List<String?> ufOrgaoEmissorSelecionadasIda = [];

  List<String?> ufOrgaoEmissorSelecionadasVolta = [];

  ClienteWeb? clienteWeb = ClienteWeb(id: 0);

  PurchaseRequest? purchaseRequest = PurchaseRequest(forwards: []);

  int formaDePagamentoSelecionada = 0;

  final ParcelaStore parcelaStore = Modular.get();

  ParcelaStatus parcelaStatus = ParcelaStatus();

  late VoidCallback removerParcelaStoreObserver;
  late VoidCallback removerPagamentoViaPixStoreObserver;
  late VoidCallback removerPagamentoCartaoStoreObserver;

  List<String> parcelas = <String>[];
  Parcela? parcelaEscolhida = null;

  final PagamentoStore pagamentoStore = Modular.get();
  final PagamentoViaPixStore pagamentoViaPixStore = Modular.get();

  double taxaServico = 0.0;
  double taxaEmbarque = 0.0;
  double valorTotal = 0.0;
  double valorTotalInicial = 0.0;
  double valorTotalComJuros = 0.0;
  bool isExpanded = false;

  String? parcelaSelecionada;

  PagamentoViaPixStatus pagamentoViaPixStatus = PagamentoViaPixStatus();

  String base64StringQrCode = '';

  final int totalDeTempo = 5 * 60 * 1000;
  late int endTime;
  bool tempoExpirado = false;

  var pagamentoEmProcessamento = true;

  String? paymentToken;

  final maskFormatterTelefone = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 231, 231, 231),
      body: buildComponentsDaTela(),
    );
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
                      buildCabecalho(),
                      clienteWeb?.cpf == null || clienteWeb?.cpf == ''
                          ? buildWidgetDadosDoClienteNecessarios()
                          : Container(),
                      (purchaseRequest?.forwards?.isNotEmpty ?? false)
                          ? buildWidgetInformacoesDaCompraDeIda()
                          : Container(),
                      (purchaseRequest?.backwards?.isNotEmpty ?? false)
                          ? buildWidgetInformacoesDaCompraDeVolta()
                          : Container(),
                      buildWidgetAreaDePagamento(),
                      buildWidgetInformacoesDeValores(),
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

  @override
  void dispose() {
    removerParcelaStoreObserver();
    removerPagamentoViaPixStoreObserver();
    removerPagamentoCartaoStoreObserver();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    carregarPurchaseRequest();
    carregarClienteWeb();
    getParcelas();

    removerParcelaStoreObserver =
        parcelaStore.observer(onState: (ParcelaStatus parcelaStatus) {
      this.parcelaStatus = parcelaStatus;
      calcularParcela();
      pagamentoEmProcessamento = false;
      setState(() {});
    });

    removerPagamentoViaPixStoreObserver = pagamentoViaPixStore.observer(
      onState: (PagamentoViaPixStatus pagamentoViaPixStatus) {
        this.pagamentoViaPixStatus = pagamentoViaPixStatus;
        base64StringQrCode = pagamentoViaPixStatus.pixQRCodeUrl!;
        base64StringQrCode = base64StringQrCode.split(',').last;
        DialogDeCarregamento().esconderDialogDeCarregamento(context);
        pagamentoEmProcessamento = true;
        endTime = DateTime.now().millisecondsSinceEpoch + totalDeTempo;
        setState(() {});
      },
      onError: (error) {
        DialogDeCarregamento().esconderDialogDeCarregamento(context);
        mostrarPopup(error.toString());
      },
    );

    removerPagamentoCartaoStoreObserver = pagamentoStore.observer(
      onState: (state) {
        DialogDeCarregamento().esconderDialogDeCarregamento(context);
        exibirDialogSucessoPagamento(context);
      },
      onError: (error) {
        pagamentoEmProcessamento = false;
        DialogDeCarregamento().esconderDialogDeCarregamento(context);
        mostrarPopup(error.toString());
        setState(() {});
      },
    );
  }

  getParcelas() {
    parcelaStore.getParcelas();
  }

  iniciarTaxaServico() {
    taxaServico = 0.0;
  }

  iniciarTaxaEmbarque() {
    taxaEmbarque = 0.0;
  }

  iniciarValorTotal() {
    valorTotal = 0.0;
  }

  somarTaxaServicoViagemDeIda() {
    for (var viagemIda in purchaseRequest!.forwards!) {
      taxaServico = taxaServico +
          (viagemIda.totalTaxaServico == null
              ? 0.0
              : viagemIda.totalTaxaServico!);
    }
  }

  somarTaxaEmbarqueViagemDeIda() {
    for (var viagemIda in purchaseRequest!.forwards!) {
      taxaEmbarque = taxaEmbarque +
          (viagemIda.totalTaxaEmbarque == null
              ? 0.0
              : viagemIda.totalTaxaEmbarque!);
    }
  }

  somarTaxaEmbarqueViagemDeVolta() {
    for (var viagemIda in purchaseRequest!.backwards!) {
      taxaEmbarque = taxaEmbarque +
          (viagemIda.totalTaxaEmbarque == null
              ? 0.0
              : viagemIda.totalTaxaEmbarque!);
    }
  }

  somarTaxasDaViagemDeVolta() {
    for (var viagemVolta in purchaseRequest!.backwards!) {
      taxaServico = taxaServico +
          (viagemVolta.totalTaxaServico == null
              ? 0.0
              : viagemVolta.totalTaxaServico!);
    }
  }

  somarValorTotalDaPassagem() {
    valorTotal = taxaServico +
        taxaEmbarque +
        purchaseRequest!.totalPoltronasForward! +
        (purchaseRequest!.totalPoltronasBackward != null
            ? purchaseRequest!.totalPoltronasBackward!
            : 0.0);
    valorTotalInicial = valorTotal;
  }

  carregarTotalTaxaServicoPurchaseRequest() {
    purchaseRequest?.totalTaxaServico = taxaServico;
  }

  Future<void> carregarClienteWeb() async {
    clienteWeb = (await PurchaseRequestStorage.getClienteWeb())!;
    setState(() {});
  }

  void iniciarControllerCamposDeTextoIda() {
    for (var forward in purchaseRequest!.forwards!) {
      for (var seat in forward.seats!) {
        nomeControllersIda
            .add(TextEditingController(text: seat.passenger?.name ?? ''));
        rgControllersIda
            .add(TextEditingController(text: seat.passenger?.docNumber ?? ''));
        telefoneControllersIda
            .add(TextEditingController(text: seat.passenger?.fone ?? ''));
        orgaoEmissorControllersIda.add(
            TextEditingController(text: seat.passenger?.docDispatcher ?? ''));
        ufOrgaoEmissorSelecionadasIda.add(seat.passenger?.docUf);
      }
    }
  }

  void iniciarControllerCamposDeTextoVolta() {
    if (purchaseRequest!.backwards != null ||
        purchaseRequest!.backwards!.isNotEmpty) {
      for (var forward in purchaseRequest!.backwards!) {
        for (var seat in forward.seats!) {
          nomeControllersVolta
              .add(TextEditingController(text: seat.passenger?.name ?? ''));
          rgControllersVolta.add(
              TextEditingController(text: seat.passenger?.docNumber ?? ''));
          telefoneControllersVolta
              .add(TextEditingController(text: seat.passenger?.fone ?? ''));
          orgaoEmissorControllersVolta.add(
              TextEditingController(text: seat.passenger?.docDispatcher ?? ''));
          ufOrgaoEmissorSelecionadasVolta.add(seat.passenger?.docUf);
        }
      }
    }
  }

  calcularParcela() {
    parcelas = [];
    for (var parcela in parcelaStatus.parcelas!) {
      var precoDouble = (valorTotal / parcela.numeroParcelas!) +
          ((valorTotal) * parcela.taxa! / 100);
      var comJuros = (parcela.taxa != 0 ? "com juros" : '');

      var parcelaString =
          '${parcela.numeroParcelas}x de ${getPrecoDaPassagem(precoDouble)} ${comJuros}';

      parcelas.add(parcelaString);
    }
    parcelaSelecionada = parcelas.isNotEmpty ? parcelas[0] : null;
  }

  String getPrecoDaPassagem(double preco) {
    return NumberFormat.simpleCurrency(locale: 'pt_BR', decimalDigits: 2)
        .format(preco);
  }

  Future<void> carregarPurchaseRequest() async {
    purchaseRequest = await PurchaseRequestStorage.getPurchaseRequest();

    if (purchaseRequest!.abrindoTeclado == false) {
      exibirDialogNavegarParaHome(context);
      return;
    }
    iniciarControllerCamposDeTextoIda();

    iniciarTaxaServico();
    iniciarTaxaEmbarque();
    iniciarValorTotal();

    somarTaxaServicoViagemDeIda();
    //somarTaxaEmbarqueViagemDeIda();

    if (purchaseRequest!.backwards != null) {
      iniciarControllerCamposDeTextoVolta();
      somarTaxasDaViagemDeVolta();
      //  somarTaxaEmbarqueViagemDeVolta();
    }

    somarValorTotalDaPassagem();
    carregarTotalTaxaServicoPurchaseRequest();
  }

  void navegarParaTelaDeBusca() {
    Modular.to.navigate('/');
  }

  void navegarParaTelaDeLogin() {
    Modular.to.navigate('/login');
  }

  Widget buildWidgetInformacoesDeValores() {
    return Padding(
        padding: EdgeInsets.only(
          top: 0,
          left: largura > 1400 ? 300 : 100,
          right: largura > 1400 ? 300 : 100,
          bottom: 40,
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 40, right: 50, left: 50, bottom: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Resumo da Compra',
                      style: GoogleFonts.inter(
                        color: Configuracao().COR_PRINCIPAL,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Valor das passagens',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromARGB(255, 56, 56, 56),
                          ),
                        ),
                        Text(
                          getPrecoDaPassagem(
                              valorTotal - taxaServico - taxaEmbarque),
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color.fromARGB(255, 56, 56, 56),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Impostos e taxas',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromARGB(255, 56, 56, 56),
                          ),
                        ),
                        Text(
                          getPrecoDaPassagem(taxaServico + taxaEmbarque),
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color.fromARGB(255, 56, 56, 56),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 1,
                      color: Color.fromARGB(255, 227, 227, 227),
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 56, 56, 56),
                          ),
                        ),
                        Text(
                          getPrecoDaPassagem(valorTotal),
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 56, 56, 56),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            pagamentoEmProcessamento == false
                ? buildWidgetBotaoRealizarPagamento()
                : Container(),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Ao clicar em compra você aceita nossos ',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromARGB(255, 56, 56, 56),
                  ),
                ),
                InkWell(
                  onTap: navegarParaTelaDeTermosDeUso,
                  child: Text(
                    'Termos de uso ',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 1, 162, 231),
                      decoration: TextDecoration.underline,
                      decorationColor: Color.fromARGB(255, 1, 162, 231),
                    ),
                  ),
                ),
                Text(
                  'e ',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromARGB(255, 56, 56, 56),
                  ),
                ),
                InkWell(
                  onTap: navegarParaTelaDePoliticaDePrivacidade,
                  child: Text(
                    'Política de privacidade',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 1, 162, 231),
                      decoration: TextDecoration.underline,
                      decorationColor: Color.fromARGB(255, 1, 162, 231),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  Widget buildWidgetAreaDePagamento() {
    return Padding(
      padding: EdgeInsets.only(
        top: 0,
        left: largura > 1400 ? 300 : 100,
        right: largura > 1400 ? 300 : 100,
        bottom: 20,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 40, right: 50, left: 50, bottom: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pagamento',
                style: GoogleFonts.inter(
                  color: Configuracao().COR_PRINCIPAL,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              buildWidgetAbasDePagamento(),
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: 4,
                  color: Configuracao().COR_PRINCIPAL),
              SizedBox(
                height: 20,
              ),
              formaDePagamentoSelecionada == 0
                  ? buildWidgetFormaDePagamentoComCartao()
                  : buildWidgetFormaDePagamentoComPix()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildWidgetFormaDePagamentoComPix() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Com o Pix você copia ou escaneia o código QR Code gerado em seu pedido e faz o pagamento direto pelo site ou aplicativo do seu banco, Ao continuar, você terá acesso ao QR Code e código de pagamento do PIX.',
          style: TextStyle(
            color: Color.fromARGB(255, 18, 45, 56),
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          'Após a geração do QR Code, você terá até 5 minutos para concluir o pagamento. Caso o QR Code já tenha sido gerado e você tenha realizado o pagamento, mas a tela não apresente uma confirmação automática, verifique sua caixa de e-mail, incluindo a pasta de spam, para confirmar o recebimento do voucher. Não atualize a página, pois isso pode invalidar o QR Code ou interromper o processamento do pagamento. Em caso de dúvidas ou problemas, entre em contato com o nosso suporte.',
          textAlign: TextAlign.justify,
          style: TextStyle(
            color: Color.fromARGB(255, 0, 126, 180),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          height: 30,
        ),
        base64StringQrCode != ''
            ? Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.memory(
                      base64Decode(base64StringQrCode),
                      width: 200,
                      height: 200,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 35),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 250,
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              enabled: false,
                              controller: TextEditingController(
                                  text: pagamentoViaPixStatus.pixQRCodeData),
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 14,
                                  fontFamily: Constants.FONT_DO_APP,
                                  fontWeight: FontWeight.w400),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Configuracao().COR_SECUNDARIA,
                                contentPadding: const EdgeInsets.all(15),
                                disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(127, 255, 255, 255),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          IconButton(
                            icon: Icon(Icons.copy,
                                color: Configuracao().COR_SECUNDARIA),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(
                                  text: pagamentoViaPixStatus.pixQRCodeData!));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        "Código copiado para a área de transferência")),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    CountdownTimer(
                      endTime: endTime,
                      widgetBuilder: (context, time) {
                        if (time == null) {
                          tempoExpirado = true;
                          return Text(
                            'Tempo expirado',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        }

                        return Text(
                          '${time.min ?? 0}m ${time.sec ?? 0}s',
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 126, 180),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                      onEnd: () {
                        if (!tempoExpirado) {
                          setState(() {
                            tempoExpirado = true;
                          });
                        }
                      },
                    )
                  ],
                ),
              )
            : Container()
      ],
    );
  }

  Widget buildWidgetFormaDePagamentoComCartao() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              color: Color.fromARGB(255, 198, 204, 206),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Row(
              children: [
                Text(
                  'PARCELE COM:',
                  style: GoogleFonts.inter(
                    color: Color.fromARGB(255, 18, 45, 56),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Image.asset(
                  'assets/viagem/bandeira_cartoes.png',
                  height: 30,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          'Dados do cartão',
          style: GoogleFonts.inter(
            color: Color.fromARGB(255, 18, 45, 56),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(
          height: 15,
        ),
        buildCampoDeTextoCartao(
          controller: numeroDoCartaoTextEditingController,
          hintText: 'Número do cartão',
          maxLength: 19,
          inputFormatters: [
            CreditCardNumberInputFormatter(),
          ],
        ),
        SizedBox(
          height: 13,
        ),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: buildCampoDeTextoCartao(
                controller: validadeDoCartaoTextEditingController,
                hintText: 'Validade do cartão (mm/AAAA)',
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
                  LengthLimitingTextInputFormatter(7),
                  TextInputFormatter.withFunction((oldValue, newValue) {
                    String text = newValue.text;

                    if (text.length == 2 && !text.contains('/')) {
                      text = '$text/';
                    }

                    if (text.length < oldValue.text.length) {
                      if (oldValue.text.contains('/') && text.length == 2) {
                        text = text.substring(0, 2);
                      }
                    }

                    return TextEditingValue(
                      text: text,
                      selection: TextSelection.collapsed(offset: text.length),
                    );
                  }),
                ],
              ),
            ),
            SizedBox(
              width: 13,
            ),
            Expanded(
              flex: 1,
              child: buildCampoDeTextoCartao(
                controller: cvvDoCartaoTextEditingController,
                hintText: 'CVV',
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 13,
        ),
        buildCampoDeTextoCartao(
            controller: titularDoCartaoTextEditingController,
            hintText: 'Seu nome escrito no cartão'),
        SizedBox(
          height: 20,
        ),
        Text(
          'Em quantas parcelas?',
          style: GoogleFonts.inter(
            color: Color.fromARGB(255, 18, 45, 56),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(
          height: 15,
        ),
        buildWidgetSelecaoDeParcela()
      ],
    );
  }

  Widget buildWidgetBotaoRealizarPagamento() {
    return SizedBox(
      height: 58,
      width: MediaQuery.of(context).size.width,
      child: Container(
        decoration: BoxDecoration(
          color: clienteWeb!.cpf == null || clienteWeb!.cpf == ''
              ? Colors.grey
              : Configuracao().COR_PRINCIPAL,
          borderRadius: BorderRadius.circular(30),
        ),
        child: ElevatedButton(
          onPressed: clienteWeb!.cpf == null || clienteWeb!.cpf == ''
              ? null
              : () async {
                  String? mensagemErro = verificarCamposPreenchidos();
                  if (mensagemErro != null) {
                    mostrarSnackBarFalha(mensagemErro);
                  } else {
                    verificarFormaDePagamentoSelecionada();
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
          child: Text(
            'CONFIRMAR COMPRA',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: Constants.FONT_DO_APP,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void exibirDialogNavegarParaHome(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 60,
                  ),
                  Text(
                    'O pagamento já foi concluído com sucesso. Por favor, clique no ícone "X" localizado no canto superior direito da tela para retornar à página inicial do site.',
                    textAlign: TextAlign.justify,
                    style: GoogleFonts.inter(
                      color: Color.fromARGB(255, 18, 45, 56),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.red),
                  onPressed: () {
                    Navigator.of(context).pop();
                    navegarParaTelaDeBusca();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void exibirDialogSucessoPagamento(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/animation/sucesso.gif',
                    width: 300,
                    height: 300,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    pagamento__text_sucesso_ao_realizar_pagamento,
                    textAlign: TextAlign.justify,
                    style: GoogleFonts.inter(
                      color: Color.fromARGB(255, 18, 45, 56),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.red),
                  onPressed: () {
                    Navigator.of(context).pop();
                    navegarParaTelaDeMinhasCompras();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  verificarFormaDePagamentoSelecionada() async {
    if (formaDePagamentoSelecionada == 1) {
      carregarPurchaseRequestPix();
      return;
    }
    await validarDadosCartaoInseridoPeloUsuario();
  }

  validarDadosCartaoInseridoPeloUsuario() async {
    String? mensagemErro = validarDadosCartao();
    if (mensagemErro != null) {
      mostrarSnackBarFalha(mensagemErro);
    } else {
      DialogDeCarregamento().exibirDialogDeCarregamento(context);
      await generateToken();
      //carregarPurchaseRequestCartao();
    }
  }

  Future<void> generateToken() async {
    var bandeira = getCardBrand(
      numeroDoCartaoTextEditingController.text.replaceAll(' ', ''),
    );
    await js.context.callMethod('generatePaymentToken', [
      '9f213fc8fe806fd9d7c2c5babdd6b5d8',
      bandeira,
      numeroDoCartaoTextEditingController.text.replaceAll(' ', ''),
      cvvDoCartaoTextEditingController.text,
      validadeDoCartaoTextEditingController.text.substring(0, 2),
      validadeDoCartaoTextEditingController.text.substring(3, 7)
    ]);
    monitorPaymentToken();
  }

  void monitorPaymentToken() {
    Timer.periodic(Duration(seconds: 2), (timer) {
      final paymentToken = js.context['paymentToken'];
      final paymentSuccess = js.context['paymentSuccess'];

      if (paymentSuccess != null) {
        if (paymentSuccess == true && paymentToken != null) {
          mostrarSnackBarSucesso("Token de pagamento gerado com sucesso");
          timer.cancel();
          carregarCardEncryptedData(paymentToken);
        } else if (paymentSuccess == false) {
          mostrarSnackBarFalha("Falha ao gerar o token de pagamento");
          DialogDeCarregamento().esconderDialogDeCarregamento(context);
          timer.cancel();
        }
      }
    });
  }

  void getToken() {
    final token = js.context.callMethod('getPaymentToken');
    setState(() {
      paymentToken = token;
    });
    print('Payment Token: $paymentToken');
  }

  String getCardBrand(String cardNumber) {
    if (cardNumber.startsWith(RegExp(r'^(4)'))) {
      return 'visa';
    } else if (cardNumber
        .startsWith(RegExp(r'^(51|52|53|54|55|22[2-9]|2[3-6]|27[01]|2720)'))) {
      return 'mastercard';
    } else if (cardNumber.startsWith(RegExp(r'^(34|37)'))) {
      return 'amex';
    } else if (cardNumber.startsWith(RegExp(
        r'^(401178|401179|431274|438935|451416|457393|457631|457632|504175|627780|636297|636368)'))) {
      return 'elo';
    } else if (cardNumber.startsWith(RegExp(r'^(606282|3841)'))) {
      return 'hipercard';
    } else {
      return 'unknown';
    }
  }

  carregarCardEncryptedData(String adyenEncriptedData) {
    purchaseRequest!.cardEncryptedData = adyenEncriptedData;
    carregarPurchaseRequestCartao();
  }

  Widget buildWidgetSelecaoDeParcela() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          color: Color.fromARGB(255, 198, 204, 206),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () async {
          String? selected = await showDialog<String>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Center(
                    child: Text(
                  'Selecione a parcela',
                  style: GoogleFonts.inter(
                    color: Color.fromARGB(255, 18, 45, 56),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                )),
                content: SizedBox(
                  width: 100,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: parcelas.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Center(
                          child: Text(
                            parcelas[index],
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromARGB(255, 56, 56, 56),
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context, parcelas[index]);
                        },
                      );
                    },
                  ),
                ),
              );
            },
          );

          if (selected != null) {
            setState(() {
              parcelaSelecionada = selected;
              verificarParcelaEscolhidaValorTotal();
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                parcelaSelecionada ?? '',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromARGB(255, 56, 56, 56),
                ),
              ),
              Row(
                children: [
                  Text(
                    'Valor total: ${getPrecoDaPassagem(valorTotal)}',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 126, 180),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Icon(Icons.keyboard_arrow_down_outlined,
                      size: 22, color: Color.fromARGB(255, 0, 69, 99)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void calcularValorComTaxa(Parcela parcela) {
    var valorParcelaSemJuros = valorTotalInicial / parcela.numeroParcelas!;

    var valorJurosPorParcela = valorTotalInicial * (parcela.taxa! / 100);

    valorTotal =
        (valorParcelaSemJuros + valorJurosPorParcela) * parcela.numeroParcelas!;
    setState(() {});
  }

  Widget buildWidgetAbasDePagamento() {
    return Row(
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: pagamentoEmProcessamento == false
                ? () {
                    setState(() {
                      formaDePagamentoSelecionada = 0;
                    });
                  }
                : null,
            child: Container(
              height: 40,
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: formaDePagamentoSelecionada == 0
                    ? Configuracao().COR_PRINCIPAL
                    : Color.fromARGB(255, 204, 219, 225),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
              ),
              child: Center(
                child: Text(
                  'CARTÃO DE CRÉDITO',
                  style: TextStyle(
                    color: formaDePagamentoSelecionada == 0
                        ? Colors.white
                        : Color.fromARGB(255, 18, 45, 56),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 8,
        ),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: pagamentoEmProcessamento == false
                ? () {
                    setState(() {
                      formaDePagamentoSelecionada = 1;
                      valorTotal = valorTotalInicial;
                      calcularParcela();
                    });
                  }
                : null,
            child: Container(
              height: 40,
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: formaDePagamentoSelecionada == 1
                    ? Configuracao().COR_PRINCIPAL
                    : Color.fromARGB(255, 204, 219, 225),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
                border: Border(
                  right: BorderSide(width: 0.1),
                  left: BorderSide.none,
                ),
              ),
              child: Center(
                child: Text(
                  'PIX',
                  style: TextStyle(
                    color: formaDePagamentoSelecionada == 1
                        ? Colors.white
                        : Color.fromARGB(255, 18, 45, 56),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildWidgetInformacoesDaCompraDeIda() {
    return Padding(
      padding: EdgeInsets.only(
        top: 40,
        left: largura > 1400 ? 300 : 100,
        right: largura > 1400 ? 300 : 100,
        bottom: 0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...List.generate(
            purchaseRequest!.forwards!.length,
            (index) {
              final forward = purchaseRequest!.forwards![index];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                margin: EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 40, right: 50, left: 50, bottom: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Trecho de ida ${index + 1}',
                            style: GoogleFonts.inter(
                              color: Configuracao().COR_PRINCIPAL,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            forward.travel!.service!,
                            style: GoogleFonts.inter(
                              color: Color.fromARGB(255, 10, 10, 10),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${getDiaSemanaEmPortugues(forward.travel!.departure!)}, ${forward.travel!.departure!.substring(8, 10)} de ${getMesEmPortugues(forward.travel!.departure!)}',
                        style: GoogleFonts.inter(
                          color: Color.fromARGB(255, 10, 10, 10),
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Icon(
                            Icons.circle_outlined,
                            color: Color.fromARGB(255, 0, 126, 180),
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            forward.travel!.departure!.substring(11, 16) +
                                ' - ' +
                                forward.travel!.departure!.substring(8, 10) +
                                '/' +
                                forward.travel!.departure!.substring(5, 7),
                            style: GoogleFonts.inter(
                              color: Color.fromARGB(255, 10, 10, 10),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 15),
                          Text(
                            CorrecaoDeTexto().getNomeDosTrechosCorrigidos(
                                    forward.origin!.name!) +
                                ' (' +
                                forward.origin!.uf! +
                                ') ',
                            style: GoogleFonts.inter(
                              color: Color.fromARGB(255, 10, 10, 10),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Dash(
                          direction: Axis.vertical,
                          length: 10,
                          dashLength: 3,
                          dashColor: Color.fromARGB(255, 0, 126, 180),
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(width: 3.5),
                          Icon(
                            Icons.timer_outlined,
                            color: Color.fromARGB(255, 0, 126, 180),
                            size: 14,
                          ),
                          SizedBox(width: 10),
                          Text(
                            calcularDuracaoDaViagem(forward.travel!.departure!,
                                forward.travel!.arrival!),
                            style: GoogleFonts.inter(
                              color: Color.fromARGB(255, 1, 162, 231),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Dash(
                          direction: Axis.vertical,
                          length: 10,
                          dashLength: 3,
                          dashColor: Color.fromARGB(255, 0, 126, 180),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_sharp,
                            size: 20,
                            color: Color.fromARGB(255, 0, 126, 180),
                          ),
                          SizedBox(width: 8),
                          Text(
                            forward.travel!.arrival!.substring(11, 16) +
                                ' - ' +
                                forward.travel!.arrival!.substring(8, 10) +
                                '/' +
                                forward.travel!.arrival!.substring(5, 7),
                            style: GoogleFonts.inter(
                              color: Color.fromARGB(255, 10, 10, 10),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 15),
                          Text(
                            CorrecaoDeTexto().getNomeDosTrechosCorrigidos(
                                    forward.destination!.name!) +
                                ' (' +
                                forward.destination!.uf! +
                                ') ',
                            style: GoogleFonts.inter(
                              color: Color.fromARGB(255, 10, 10, 10),
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 1,
                        color: Color.fromARGB(118, 158, 158, 158),
                      ),
                      SizedBox(height: 10),
                      ...List.generate(forward.seats!.length, (seatIndex) {
                        final seat = forward.seats![seatIndex];
                        return Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Theme(
                                data: Theme.of(context)
                                    .copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  tilePadding: EdgeInsets.zero,
                                  leading: Container(
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 231, 231, 231),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    height: 35,
                                    width: 35,
                                    child: Center(
                                      child: Text(
                                        seat.label ?? '',
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Color.fromARGB(255, 0, 126, 180),
                                        ),
                                      ),
                                    ),
                                  ),
                                  title: Row(
                                    children: [
                                      Text(
                                        'Clique para preencher dados do',
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              Color.fromARGB(255, 10, 10, 10),
                                        ),
                                      ),
                                      Text(
                                        ' Passageiro ${seatIndex + 1}',
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Color.fromARGB(255, 10, 10, 10),
                                        ),
                                      ),
                                    ],
                                  ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 50, right: 50, top: 10),
                                      child: Column(
                                        children: [
                                          buildCampoDeTextoPassageiro(
                                            controller:
                                                nomeControllersIda[seatIndex],
                                            labelText: 'Nome do passageiro*',
                                          ),
                                          SizedBox(height: 10),
                                          buildCampoDeTextoPassageiro(
                                            controller: telefoneControllersIda[
                                                seatIndex],
                                            labelText:
                                                'Telefone do passageiro*',
                                            inputFormatters: [
                                              maskFormatterTelefone
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          buildCampoDeTextoPassageiro(
                                            controller:
                                                rgControllersIda[seatIndex],
                                            labelText: 'Número do RG*',
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child:
                                                    buildCampoDeTextoPassageiro(
                                                  controller:
                                                      orgaoEmissorControllersIda[
                                                          seatIndex],
                                                  labelText: 'Orgão emissor*',
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .allow(RegExp(
                                                            r'[a-zA-Z]')),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Expanded(
                                                flex: 1,
                                                child: buildDropdownUF(
                                                  selectedValue:
                                                      ufOrgaoEmissorSelecionadasIda[
                                                          seatIndex],
                                                  onChanged: (String? value) {
                                                    setState(() {
                                                      ufOrgaoEmissorSelecionadasIda[
                                                          seatIndex] = value;
                                                    });
                                                  },
                                                  labelText: 'UF*',
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildWidgetInformacoesDaCompraDeVolta() {
    return Padding(
      padding: EdgeInsets.only(
        left: largura > 1400 ? 300 : 100,
        right: largura > 1400 ? 300 : 100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...List.generate(
            purchaseRequest!.backwards!.length,
            (index) {
              final backwards = purchaseRequest!.backwards![index];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                margin: EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 40, right: 50, left: 50, bottom: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Trecho de volta ${index + 1}',
                            style: GoogleFonts.inter(
                              color: Configuracao().COR_PRINCIPAL,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            backwards.travel!.service!,
                            style: GoogleFonts.inter(
                              color: Color.fromARGB(255, 10, 10, 10),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${getDiaSemanaEmPortugues(backwards.travel!.departure!)}, ${backwards.travel!.departure!.substring(8, 10)} de ${getMesEmPortugues(backwards.travel!.departure!)}',
                        style: GoogleFonts.inter(
                          color: Color.fromARGB(255, 10, 10, 10),
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Icon(
                            Icons.circle_outlined,
                            color: Color.fromARGB(255, 0, 126, 180),
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            backwards.travel!.departure!.substring(11, 16) +
                                ' - ' +
                                backwards.travel!.departure!.substring(8, 10) +
                                '/' +
                                backwards.travel!.departure!.substring(5, 7),
                            style: GoogleFonts.inter(
                              color: Color.fromARGB(255, 10, 10, 10),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 15),
                          Text(
                            CorrecaoDeTexto().getNomeDosTrechosCorrigidos(
                                    backwards.origin!.name!) +
                                ' (' +
                                backwards.origin!.uf! +
                                ') ',
                            style: GoogleFonts.inter(
                              color: Color.fromARGB(255, 10, 10, 10),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Dash(
                          direction: Axis.vertical,
                          length: 10,
                          dashLength: 3,
                          dashColor: Color.fromARGB(255, 0, 126, 180),
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(width: 3.5),
                          Icon(
                            Icons.timer_outlined,
                            color: Color.fromARGB(255, 0, 126, 180),
                            size: 14,
                          ),
                          SizedBox(width: 10),
                          Text(
                            calcularDuracaoDaViagem(
                                backwards.travel!.departure!,
                                backwards.travel!.arrival!),
                            style: GoogleFonts.inter(
                              color: Color.fromARGB(255, 1, 162, 231),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Dash(
                          direction: Axis.vertical,
                          length: 10,
                          dashLength: 3,
                          dashColor: Color.fromARGB(255, 0, 126, 180),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_sharp,
                            size: 20,
                            color: Color.fromARGB(255, 0, 126, 180),
                          ),
                          SizedBox(width: 8),
                          Text(
                            backwards.travel!.arrival!.substring(11, 16) +
                                ' - ' +
                                backwards.travel!.arrival!.substring(8, 10) +
                                '/' +
                                backwards.travel!.arrival!.substring(5, 7),
                            style: GoogleFonts.inter(
                              color: Color.fromARGB(255, 10, 10, 10),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 15),
                          Text(
                            CorrecaoDeTexto().getNomeDosTrechosCorrigidos(
                                    backwards.destination!.name!) +
                                ' (' +
                                backwards.destination!.uf! +
                                ') ',
                            style: GoogleFonts.inter(
                              color: Color.fromARGB(255, 10, 10, 10),
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 1,
                        color: Color.fromARGB(118, 158, 158, 158),
                      ),
                      SizedBox(height: 10),
                      ...List.generate(backwards.seats!.length, (seatIndex) {
                        final seat = backwards.seats![seatIndex];
                        return Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Theme(
                                data: Theme.of(context)
                                    .copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  tilePadding: EdgeInsets.zero,
                                  leading: Container(
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 231, 231, 231),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    height: 35,
                                    width: 35,
                                    child: Center(
                                      child: Text(
                                        seat.label ?? '',
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Color.fromARGB(255, 0, 126, 180),
                                        ),
                                      ),
                                    ),
                                  ),
                                  title: Row(
                                    children: [
                                      Text(
                                        'Clique para preencher dados do',
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              Color.fromARGB(255, 10, 10, 10),
                                        ),
                                      ),
                                      Text(
                                        ' Passageiro ${seatIndex + 1}',
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Color.fromARGB(255, 10, 10, 10),
                                        ),
                                      ),
                                    ],
                                  ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 50, right: 50, top: 10),
                                      child: Column(
                                        children: [
                                          buildCampoDeTextoPassageiro(
                                            controller:
                                                nomeControllersVolta[seatIndex],
                                            labelText: 'Nome do passageiro*',
                                          ),
                                          SizedBox(height: 10),
                                          buildCampoDeTextoPassageiro(
                                            controller:
                                                telefoneControllersVolta[
                                                    seatIndex],
                                            labelText:
                                                'Telefone do passageiro*',
                                            inputFormatters: [
                                              maskFormatterTelefone
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          buildCampoDeTextoPassageiro(
                                            controller:
                                                rgControllersVolta[seatIndex],
                                            labelText: 'Número do RG*',
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child:
                                                    buildCampoDeTextoPassageiro(
                                                  controller:
                                                      orgaoEmissorControllersVolta[
                                                          seatIndex],
                                                  labelText: 'Orgão emissor*',
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .allow(RegExp(
                                                            r'[a-zA-Z]')),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Expanded(
                                                flex: 1,
                                                child: buildDropdownUF(
                                                  selectedValue:
                                                      ufOrgaoEmissorSelecionadasVolta[
                                                          index],
                                                  onChanged: (String? value) {
                                                    setState(() {
                                                      ufOrgaoEmissorSelecionadasVolta[
                                                          index] = value;
                                                    });
                                                  },
                                                  labelText: 'UF*',
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildDropdownUF({
    required String? selectedValue,
    required Function(String?) onChanged,
    required String labelText,
  }) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Color.fromARGB(255, 158, 169, 174),
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18.5, horizontal: 16.0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 198, 204, 206),
          ),
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
        color: const Color.fromARGB(255, 56, 56, 56),
      ),
      items: [
        'AC',
        'AL',
        'AP',
        'AM',
        'BA',
        'CE',
        'DF',
        'ES',
        'GO',
        'MA',
        'MT',
        'MS',
        'MG',
        'PA',
        'PB',
        'PR',
        'PE',
        'PI',
        'RJ',
        'RN',
        'RS',
        'RO',
        'RR',
        'SC',
        'SP',
        'SE',
        'TO'
      ].map((String uf) {
        return DropdownMenuItem<String>(
          value: uf,
          child: Text(uf),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) =>
          value == null ? 'Por favor, selecione uma UF' : null,
    );
  }

  Widget buildCampoDeTextoCartao({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: hintText,
        labelStyle: GoogleFonts.inter(
          color: Color.fromARGB(255, 158, 169, 174),
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 198, 204, 206),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Configuracao().COR_PRINCIPAL,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16),
        counterText: maxLength != null ? '' : null,
      ),
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: const Color.fromARGB(255, 56, 56, 56),
      ),
    );
  }

  Widget buildCampoDeTextoPassageiro({
    required TextEditingController controller,
    required String labelText,
    int maxLines = 1,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: GoogleFonts.inter(
          color: Color.fromARGB(255, 158, 169, 174),
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 198, 204, 206),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Configuracao().COR_PRINCIPAL,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16),
        counterText: maxLength != null ? '' : null,
      ),
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: const Color.fromARGB(255, 56, 56, 56),
      ),
    );
  }

  String getDiaSemanaEmPortugues(String arrival) {
    String year = arrival.substring(0, 4);
    String month = arrival.substring(5, 7);
    String day = arrival.substring(8, 10);

    DateTime dateTime = DateTime.parse("$year-$month-$day");

    String diaSemana = DateFormat('EEEE', 'pt_BR').format(dateTime);
    return capitalizeFirstLetter(diaSemana);
  }

  String getMesEmPortugues(String arrival) {
    String year = arrival.substring(0, 4);
    String month = arrival.substring(5, 7);
    String day = arrival.substring(8, 10);

    DateTime dateTime = DateTime.parse("$year-$month-$day");

    String mes = DateFormat('MMMM', 'pt_BR').format(dateTime);
    return capitalizeFirstLetter(mes);
  }

  String calcularDuracaoDaViagem(String departure, String arrival) {
    DateTime departureTime = DateTime.parse(departure);
    DateTime arrivalTime = DateTime.parse(arrival);

    Duration difference = arrivalTime.difference(departureTime);

    String horas = difference.inHours.toString().padLeft(2, '0');
    String minutos = (difference.inMinutes % 60).toString().padLeft(2, '0');

    return '$horas:$minutos';
  }

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  Widget buildWidgetDadosDoClienteNecessarios() {
    return Padding(
      padding: EdgeInsets.only(
          top: 40,
          left: largura > 1400 ? 300 : 100,
          right: largura > 1400 ? 300 : 100,
          bottom: 40),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10), // Define o raio da borda
        child: Container(
          height: 50,
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Row(
              children: [
                Icon(
                  Icons.info,
                  color: Color.fromARGB(255, 0, 69, 99),
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Para continuar com sua compra, preencha os dados necessários em seu cadastro.',
                  style: GoogleFonts.inter(
                      color: Color.fromARGB(255, 0, 69, 99),
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(width: 10),
                InkWell(
                  onTap: navegarParaTelaDeMeusDados,
                  child: Text(
                    'Meus dados',
                    style: GoogleFonts.inter(
                      color: Color.fromARGB(255, 0, 69, 99),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCabecalho() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            Container(
              color: Color.fromARGB(255, 231, 231, 231),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  SizedBox(
                    height: 35,
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
                        '/ RESUMO DA COMPRA',
                        style: GoogleFonts.inter(
                            color: Configuracao().COR_PRINCIPAL,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Resumo da Compra',
                    style: GoogleFonts.inter(
                        color: Configuracao().COR_PRINCIPAL,
                        fontSize: 30,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
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

  void mostrarPopup(String mensagem) {
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
                  mensagem,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                      fontSize: 14, color: Configuracao().COR_SECUNDARIA),
                ),
              ],
            ),
          ),
          actions: <Widget>[
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

  carregarPurchaseRequestPix() async {
    await carregarPassageiroPurchaseRequest();

    purchaseRequest!.clienteWeb = clienteWeb;
    purchaseRequest!.clienteWeb!.ativo = true;
    purchaseRequest!.clienteWeb!.concordaTermos = false;
    purchaseRequest!.clienteWeb!.id = clienteWeb!.id;

    purchaseRequest?.kreditKard = null;

    purchaseRequest?.paymentMethod = Constants.PAGAMENTO_VIA_PIX;
    purchaseRequest?.cardEncryptedData = '';

    purchaseRequest?.installments = 1;
    purchaseRequest?.total = valorTotal;

    purchaseRequest?.totalTaxaEmbarque = taxaEmbarque;
    purchaseRequest?.totalTaxaServico = taxaServico;

    purchaseRequest?.totalPoltronas = purchaseRequest!.totalPoltronasForward! +
        (purchaseRequest!.totalPoltronasBackward != null
            ? purchaseRequest!.totalPoltronasBackward!
            : 0.0);

    purchaseRequest?.clienteWeb!.deleted = false;

    DialogDeCarregamento().exibirDialogDeCarregamento(context);
    pagamentoViaPixStore.realizarPagamento(purchaseRequest!);
  }

  verificarParcelaEscolhida() {
    for (var parcela in parcelaStatus.parcelas!) {
      int numeroParcela = int.parse(parcelaSelecionada!.split('x')[0].trim());
      if (numeroParcela == parcela.numeroParcelas) {
        parcelaEscolhida = parcela;
      }
    }
  }

  verificarParcelaEscolhidaValorTotal() {
    for (var parcela in parcelaStatus.parcelas!) {
      int numeroParcela = int.parse(parcelaSelecionada!.split('x')[0].trim());
      if (numeroParcela == parcela.numeroParcelas) {
        parcelaEscolhida = parcela;
        calcularValorComTaxa(parcela);
      }
    }
  }

  carregarPurchaseRequestCartao() async {
    await verificarParcelaEscolhida();
    await carregarPassageiroPurchaseRequest();
    purchaseRequest!.clienteWeb = clienteWeb;
    purchaseRequest?.clienteWeb!.ativo = true;
    purchaseRequest?.clienteWeb!.concordaTermos = false;
    purchaseRequest!.clienteWeb!.id = clienteWeb!.id;

    purchaseRequest?.paymentMethod = Constants.PAGAMENTO_VIA_CARD;

    purchaseRequest?.kreditKard = KreditKard(
        status: Constants.STATUS_PENDING,
        bin: numeroDoCartaoTextEditingController.text
            .replaceAll(' ', '')
            .substring(0, 6),
        last4: numeroDoCartaoTextEditingController.text.substring(15, 19),
        expirationDate:
            validadeDoCartaoTextEditingController.text.replaceAll("/", ''),
        holderName: titularDoCartaoTextEditingController.text);

    purchaseRequest?.installments = parcelaEscolhida!.numeroParcelas;
    purchaseRequest?.total = valorTotal;

    purchaseRequest?.totalTaxaEmbarque = taxaEmbarque;
    purchaseRequest?.totalTaxaServico = taxaServico;

    purchaseRequest?.totalPoltronas = purchaseRequest!.totalPoltronasForward! +
        (purchaseRequest!.totalPoltronasBackward != null
            ? purchaseRequest!.totalPoltronasBackward!
            : 0.0);

    purchaseRequest?.clienteWeb!.deleted = false;
    pagamentoEmProcessamento = true;
    pagamentoStore.realizarPagamento(purchaseRequest!);
  }

  carregarPassageiroPurchaseRequest() {
    int index = 0;

    for (var forward in purchaseRequest!.forwards!) {
      for (var seat in forward.seats!) {
        if (index < nomeControllersIda.length) {
          seat.passenger?.name = nomeControllersIda[index].text;
          seat.passenger?.docNumber = rgControllersIda[index].text;
          seat.passenger?.fone =
              telefoneControllersIda[index].text.replaceAll(RegExp(r'\D'), '');
          seat.passenger?.docDispatcher =
              orgaoEmissorControllersIda[index].text;
          seat.passenger?.docUf = ufOrgaoEmissorSelecionadasIda[index];
          index++;
        }
      }
      index = 0;
    }

    index = 0;

    if (purchaseRequest!.backwards != null) {
      for (var backward in purchaseRequest!.backwards!) {
        for (var seat in backward.seats!) {
          if (index < nomeControllersVolta.length) {
            seat.passenger?.name = nomeControllersVolta[index].text;
            seat.passenger?.docNumber = rgControllersVolta[index].text;
            seat.passenger?.fone = telefoneControllersVolta[index]
                .text
                .replaceAll(RegExp(r'\D'), '');
            seat.passenger?.docDispatcher =
                orgaoEmissorControllersVolta[index].text;
            seat.passenger?.docUf = ufOrgaoEmissorSelecionadasVolta[index];
            index++;
          }
        }
        index = 0;
      }
    }
  }

  String? verificarCamposPreenchidos() {
    for (var forward in purchaseRequest!.forwards!) {
      for (var seat in forward.seats!) {
        int index = forward.seats!.indexOf(seat);

        if (nomeControllersIda[index].text.isEmpty) {
          return 'Nome do passageiro está vazio';
        } else if (nomeControllersIda[index].text.split(' ').length < 2) {
          return 'Nome do passageiro deve ser composto (exemplo: Jorgin O)';
        }

        if (rgControllersIda[index].text.isEmpty) {
          return 'Número do RG está vazio';
        }
        if (telefoneControllersIda[index].text.isEmpty) {
          return 'Número do telefone está vazio';
        }
        if (orgaoEmissorControllersIda[index].text.isEmpty) {
          return 'Órgão emissor está vazio';
        }
        if (ufOrgaoEmissorSelecionadasIda[index] == null ||
            ufOrgaoEmissorSelecionadasIda[index]!.isEmpty) {
          return 'UF do órgão emissor está vazio';
        }
      }
    }

    if (purchaseRequest!.backwards != null &&
        purchaseRequest!.backwards!.isNotEmpty) {
      for (var backward in purchaseRequest!.backwards!) {
        for (var seat in backward.seats!) {
          int index = backward.seats!.indexOf(seat);

          if (nomeControllersVolta[index].text.isEmpty) {
            return 'Nome do passageiro (volta) está vazio';
          } else if (nomeControllersVolta[index].text.split(' ').length < 2) {
            return 'Nome do passageiro (volta) deve ser composto (exemplo: Jorgin O)';
          }

          if (rgControllersVolta[index].text.isEmpty) {
            return 'Número do RG (volta) está vazio';
          }
          if (telefoneControllersVolta[index].text.isEmpty) {
            return 'Número do telefone (volta) está vazio';
          }
          if (orgaoEmissorControllersVolta[index].text.isEmpty) {
            return 'Órgão emissor (volta) está vazio';
          }
          if (ufOrgaoEmissorSelecionadasVolta[index] == null ||
              ufOrgaoEmissorSelecionadasVolta[index]!.isEmpty) {
            return 'UF do órgão emissor (volta) está vazio';
          }
        }
      }
    }

    return null;
  }

  String? validarDadosCartao() {
    String numeroCartao =
        numeroDoCartaoTextEditingController.text.replaceAll(RegExp(r'\D'), '');
    if (numeroCartao.isEmpty) {
      return 'Número do cartão não pode estar vazio';
    }
    if (numeroCartao.length < 13 || numeroCartao.length > 19) {
      return 'Número do cartão deve ter entre 13 e 19 dígitos';
    }

    String validade = validadeDoCartaoTextEditingController.text;
    if (validade.isEmpty) {
      return 'Validade do cartão não pode estar vazia';
    }
    if (!RegExp(r'^\d{2}/\d{4}$').hasMatch(validade)) {
      return 'Validade do cartão deve estar no formato mm/AAAA';
    }
    List<String> validadeParts = validade.split('/');
    int mes = int.parse(validadeParts[0]);
    int ano = int.parse(validadeParts[1]);

    if (mes < 1 || mes > 12) {
      return 'Mês da validade deve ser entre 01 e 12';
    }

    int anoAtual = DateTime.now().year;
    if (ano < anoAtual || (ano == anoAtual && mes < DateTime.now().month)) {
      return 'Ano da validade deve ser maior ou igual ao ano atual';
    }

    String cvv = cvvDoCartaoTextEditingController.text;
    if (cvv.isEmpty) {
      return 'CVV não pode estar vazio';
    }
    if (cvv.length < 3 || cvv.length > 4) {
      return 'CVV deve ter 3 ou 4 dígitos';
    }

    String titular = titularDoCartaoTextEditingController.text;
    if (titular.isEmpty) {
      return 'Nome do titular não pode estar vazio';
    }
    if (titular.split(' ').length < 2) {
      return 'O nome do titular deve ter pelo menos nome e sobrenome';
    }

    return null;
  }

  void navegarParaTelaFaleConosco() {
    Modular.to.navigate('/fale_conosco');
  }

  void navegarParaTelaDeTermosDeUso() {
    Modular.to.navigate('/termos_de_uso');
  }

  void navegarParaTelaDePoliticaDePrivacidade() {
    Modular.to.navigate('/politica');
  }

  navegarParaTelaDeMinhasCompras() {
    Modular.to.navigate('/compras');
  }

  navegarParaTelaDeMeusDados() {
    Modular.to.navigate('/dados');
  }

  navegarParaTelaDeTelefoneDasAgencias() {
    Modular.to.navigate('/agencias');
  }

  navegarParaTelaDeComoComprar() {
    Modular.to.navigate('/como_comprar');
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
        borderRadius: BorderRadius.circular(12),
      ),
    ).then((value) {
      if (value == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => navegarParaTelaDeMeusDados()),
        );
      }
      if (value == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => navegarParaTelaDeMinhasCompras()),
        );
      }
    });
  }

  void mostrarPopupSucesso(String mensagem) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: 300,
            child: Text(mensagem,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                    fontSize: 16, color: Configuracao().COR_SECUNDARIA)),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Fechar', style: GoogleFonts.inter(fontSize: 14)),
              onPressed: () {
                Navigator.of(context).pop();
                navegarParaTelaDeLogin();
              },
            ),
          ],
        );
      },
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
