import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:montesBelos/core/utils/constants/configuracao.dart';
import 'package:montesBelos/features/data/models/fale_conosco_request.dart';
import 'package:montesBelos/features/data/models/purchase_request.dart';
import 'package:montesBelos/features/presenter/components/dialog_carregamento_widget.dart';
import 'package:montesBelos/features/presenter/components/drawer_widget_mobile.dart';
import 'package:montesBelos/features/presenter/components/footer_widget_mobile.dart';
import 'package:montesBelos/features/presenter/components/snack_bar_personalizado_widget.dart';
import 'package:montesBelos/features/presenter/store/fale_conosco_store.dart';
import 'package:montesBelos/features/presenter/store/purchase_request_store.dart';

class FaleConoscoPageMobile extends StatefulWidget {
  @override
  _FaleConoscoPageMobileState createState() => _FaleConoscoPageMobileState();
}

class _FaleConoscoPageMobileState extends State<FaleConoscoPageMobile> {
  double largura = 0.0;

  ClienteWeb? clienteWeb;

  PurchaseRequest? purchaseRequest;

  final FaleConoscoStore faleConoscoStore = Modular.get();
  final TextEditingController nomeTextEditingController =
      TextEditingController();
  final TextEditingController emailTextEditingController =
      TextEditingController();
  final TextEditingController assuntoTextEditingController =
      TextEditingController();
  final TextEditingController mensagemTextEditingController =
      TextEditingController();

  late VoidCallback removerFaleConoscosObserver;

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
              children: [buildAreaDeInformacoes(), FooterMobile()],
            ),
          ),
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    carregarPurchaseRequest();
    carregarClienteWeb();

    removerFaleConoscosObserver = faleConoscoStore.observer(
      onState: (String mensagem) {
        DialogDeCarregamento().esconderDialogDeCarregamento(context);
        mostrarSnackBarSucesso(
            'E-mail enviado com sucesso para Montes Belos. Entraremos em contato com você em breve');
        limparCamposDeTexto();
        setState(() {});
      },
      onError: (e) {
        DialogDeCarregamento().esconderDialogDeCarregamento(context);
        mostrarSnackBarFalha(e.toString());
      },
    );
  }

  @override
  void dispose() {
    removerFaleConoscosObserver();
    super.dispose();
  }

  void limparCamposDeTexto() {
    nomeTextEditingController.clear();
    emailTextEditingController.clear();
    assuntoTextEditingController.clear();
    mensagemTextEditingController.clear();
  }

  Future<void> carregarClienteWeb() async {
    clienteWeb = (await PurchaseRequestStorage.getClienteWeb())!;
    setState(() {});
  }

  Future<void> carregarPurchaseRequest() async {
    purchaseRequest = await PurchaseRequestStorage.getPurchaseRequest();
  }

  void navegarParaTelaDeBusca() {
    Modular.to.navigate('/home');
  }

  void navegarParaTelaDeLogin() {
    Modular.to.navigate('/login');
  }

  void navegarParaTelaDeResumoDeCompra() {}

  Widget buildAreaDeInformacoes() {
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
                            color: Configuracao().COR_SECUNDARIA,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '/ FALE CONOSCO',
                        style: GoogleFonts.inter(
                            color: Configuracao().COR_PRINCIPAL,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Fale Conosco',
                    style: GoogleFonts.inter(
                        color: Configuracao().COR_PRINCIPAL,
                        fontSize: 30,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                ],
              ),
            ),
            Container(
              height: 240,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/viagem/banner_faleconosco.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/home/onibus_home.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      height: 200,
                      width: 400,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              height: 750,
              width: MediaQuery.of(context).size.width,
            ),
          ],
        ),
        Positioned(
          top: 345,
          child: Column(
            children: [
              Container(
                width: 400,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Envie-nos uma mensagem',
                      style: GoogleFonts.inter(
                        color: Configuracao().COR_SECUNDARIA,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildTextField(
                      controller: nomeTextEditingController,
                      hintText: 'Seu nome*',
                    ),
                    SizedBox(height: 15),
                    _buildTextField(
                      controller: emailTextEditingController,
                      hintText: 'Seu endereço de e-mail*',
                    ),
                    SizedBox(height: 15),
                    _buildTextField(
                      controller: assuntoTextEditingController,
                      hintText: 'Seu assunto*',
                    ),
                    SizedBox(height: 15),
                    _buildTextField(
                      controller: mensagemTextEditingController,
                      hintText: 'Sua mensagem*',
                      maxLines: 3,
                      maxLength: 200,
                    ),
                    SizedBox(height: 35),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          if (nomeTextEditingController.text.isNotEmpty ||
                              emailTextEditingController.text.isNotEmpty ||
                              assuntoTextEditingController.text.isNotEmpty ||
                              mensagemTextEditingController.text.isNotEmpty) {
                            DialogDeCarregamento()
                                .exibirDialogDeCarregamento(context);
                            faleConoscoStore.enviarNotificacao(
                                FaleConoscoRequest(
                                    nome: nomeTextEditingController.text,
                                    email: emailTextEditingController.text,
                                    assunto: assuntoTextEditingController.text,
                                    mensagem:
                                        mensagemTextEditingController.text,
                                    emailDaEmpresaDestinataria:
                                        'sac.montesbelos@gmail.com'));
                            return;
                          }
                          mostrarSnackBarFalha('Todos campos são obrigatórios');
                        },
                        child: Container(
                          height: 45,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Configuracao().COR_SECUNDARIA,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(
                              "Enviar mensagem",
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Row(
                children: [
                  Icon(Icons.email, color: Color.fromARGB(255, 0, 68, 97)),
                  SizedBox(width: 10),
                  Text(
                    'E-mail',
                    style: GoogleFonts.inter(
                      color: Configuracao().COR_SECUNDARIA,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Text(
                'sac.montesbelos@gmail.com',
                style: GoogleFonts.inter(
                  color: Configuracao().COR_SECUNDARIA,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(
                    Icons.support_agent,
                    color: Configuracao().COR_SECUNDARIA,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Suporte',
                    style: GoogleFonts.inter(
                      color: Configuracao().COR_SECUNDARIA,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Text(
                '(62) 99931-9109',
                style: GoogleFonts.inter(
                  color: Configuracao().COR_SECUNDARIA,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.phone, color: Color.fromARGB(255, 0, 68, 97)),
                  SizedBox(width: 10),
                  Text(
                    'Sac',
                    style: GoogleFonts.inter(
                      color: Configuracao().COR_SECUNDARIA,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Text(
                'sac.montesbelos@gmail.com',
                style: GoogleFonts.inter(
                  color: Configuracao().COR_SECUNDARIA,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Text(
                'SAC: 0800 728 8123',
                style: GoogleFonts.inter(
                  color: Configuracao().COR_SECUNDARIA,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    int? maxLength,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      maxLength: maxLength,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.inter(
          color: const Color.fromARGB(179, 158, 158, 158),
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: const Color.fromARGB(179, 158, 158, 158),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Configuracao().COR_PRINCIPAL,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        counterText: maxLength != null ? '' : null,
      ),
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Configuracao().COR_SECUNDARIA,
      ),
    );
  }

  navegarParaTelaDeServicos() {
    Modular.to.navigate('/servicos');
  }

  navegarParaTelaDeFrota() {
    Modular.to.navigate('/frota');
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
      ],
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(12), // Define as bordas arredondadas
      ),
    );
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
