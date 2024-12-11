import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:montesBelos/core/utils/constants/configuracao.dart';
import 'package:montesBelos/core/utils/constants/constants.dart';
import 'package:montesBelos/core/utils/constants/strings.dart';
import 'package:montesBelos/features/data/models/cadastrar_usuario_request.dart';
import 'package:montesBelos/features/data/models/purchase_request.dart';
import 'package:montesBelos/features/data/models/redefinir_senha_request.dart';
import 'package:montesBelos/features/domain/entities/novo_usuario_status.dart';
import 'package:montesBelos/features/presenter/components/dialog_carregamento_widget.dart';
import 'package:montesBelos/features/presenter/components/footer_widget.dart';
import 'package:montesBelos/features/presenter/components/snack_bar_personalizado_widget.dart';
import 'package:montesBelos/features/presenter/model/usuario.dart';
import 'package:montesBelos/features/presenter/store/login_store.dart';
import 'package:montesBelos/features/presenter/store/novo_usuario_store.dart';
import 'package:montesBelos/features/presenter/store/purchase_request_store.dart';
import 'package:montesBelos/features/presenter/store/redefinir_senha_store.dart';
import 'package:montesBelos/features/presenter/utils/whats_app_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class NossaFrotaPage extends StatefulWidget {
  @override
  _NossaFrotaPageState createState() => _NossaFrotaPageState();
}

class _NossaFrotaPageState extends State<NossaFrotaPage> {
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

  final NovoUsuarioStore novoUsuarioStore = Modular.get();
  final RedefinirSenhaStore redefinirSenhaStore = Modular.get();

  bool espandirImagemNovaFrota = false;
  bool espandirImagemInteriorNovaFrota = false;

  late Usuario usuario;

  var loginSocialGoogle = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                      buildAreaDeInformacao(),
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

  Future<void> carregarClienteWeb() async {
    clienteWeb = (await PurchaseRequestStorage.getClienteWeb())!;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    carregarPurchaseRequest();
    carregarClienteWeb();

    novoUsuarioStore.observer(onState: (NovoUsuarioStatus novoUsuarioStatus) {
      DialogDeCarregamento().esconderDialogDeCarregamento(context);
      mostrarSnackBarSucesso(novoUsuarioStatus.mensagem!);
    }, onError: (error) {
      DialogDeCarregamento().esconderDialogDeCarregamento(context);
      mostrarSnackBarFalha(error.toString());
    });

    loginStore.observer(
      onError: (error) {
        if (loginSocialGoogle) {
          loginSocialGoogle = false;
          novoUsuarioStore.cadastrarNovoUsuario(NovoUsuarioRequest(
              email: usuario.email,
              idDaConta: usuario.id,
              nome: usuario.nome,
              tipoDaConta: 1));
          return;
        }
        DialogDeCarregamento().esconderDialogDeCarregamento(context);
        mostrarSnackBarFalha(error.toString());
      },
      onState: (ClienteWeb clienteWeb) {
        DialogDeCarregamento().esconderDialogDeCarregamento(context);
        mostrarSnackBarSucesso('Usuário logado com sucesso');
        PurchaseRequestStorage.saveClienteWeb(clienteWeb);
        purchaseRequest == null
            ? navegarParaTelaDeBusca()
            : navegarParaTelaDeResumoDeCompra();
      },
    );

    redefinirSenhaStore.observer(
      onState: (state) {
        mostrarSnackBarSucesso(
            redefinir_senha__texto_sucesso_ao_redefinir_senha);
        DialogDeCarregamento().esconderDialogDeCarregamento(context);
      },
      onError: (error) {
        mostrarSnackBarFalha(error.toString());
        DialogDeCarregamento().esconderDialogDeCarregamento(context);
      },
    );
  }

  void mostrarPopupRecuperarSenha() {
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
                  'Recuperar Senha',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Para recuperar sua senha, preencha abaixo com o seu e-mail e enviaremos o link para redefinição.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                      fontSize: 14, color: Configuracao().COR_SECUNDARIA),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: redefinirEmailTextEditingController,
                  decoration: InputDecoration(
                    hintText: 'Seu e-mail',
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
              child: Text('Enviar', style: GoogleFonts.inter(fontSize: 14)),
              onPressed: () {
                if (redefinirEmailTextEditingController.text != '') {
                  Navigator.of(context).pop();
                  DialogDeCarregamento().exibirDialogDeCarregamento(context);
                  recuperarSenha(redefinirEmailTextEditingController.text);
                  return;
                }
                mostrarSnackBarFalha('Preencha o e-mail corretamente');
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

  Future<void> carregarPurchaseRequest() async {
    purchaseRequest = await PurchaseRequestStorage.getPurchaseRequest();
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

  void navegarParaTelaDeResumoDeCompra() {}

  Widget buildAreaDeInformacao() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [buildCabecalhoNossaFrota(), buildNossaFrotaAtualizada()],
        ),
      ],
    );
  }

  navegarParaTelaDeComoComprar() {
    Modular.to.navigate('/como_comprar');
  }

  Widget buildCabecalhoNossaFrota() {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.only(
            top: 0,
            left: largura > 1400 ? 300 : 100,
            right: largura > 1400 ? 300 : 100,
            bottom: 20),
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
                      color: Configuracao().COR_PRINCIPAL,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  '/ NOSSA FROTA ',
                  style: GoogleFonts.inter(
                      color: Configuracao().COR_SECUNDARIA,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            SizedBox(height: 15),
            Text(
              'Nossa Frota',
              style: GoogleFonts.inter(
                  color: Configuracao().COR_PRINCIPAL,
                  fontSize: 30,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              'Nossos veículos são regularmente revisados, tendo um programa de manutenção preventiva e corretiva com todos os itens de segurança atualizados, acompanhando os itens exigidos pelo fabricante. Nossos motoristas são treinados com experiência para conduzir e garantir a segurança da sua viagem.',
              textAlign: TextAlign.justify,
              style: GoogleFonts.inter(
                  color: Color.fromARGB(255, 50, 50, 50),
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNossaFrotaAtualizada() {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: 0,
                  left: largura > 1400 ? 300 : 100,
                  right: largura > 1400 ? 300 : 100,
                  bottom: 20),
              child: Column(
                children: [
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          espandirImagemNovaFrota = !espandirImagemNovaFrota;
                        });
                      },
                      child: Container(
                        height: 75,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Configuracao().COR_PRINCIPAL,
                          ),
                        ),
                        padding: EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Frota 2024',
                              style: GoogleFonts.inter(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Configuracao().COR_PRINCIPAL,
                              ),
                            ),
                            Icon(
                              espandirImagemNovaFrota
                                  ? Icons.remove
                                  : Icons.add,
                              color: Configuracao().COR_PRINCIPAL,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (espandirImagemNovaFrota) ...[
                    SizedBox(height: 25),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                height: 250,
                                width: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      8), // Bordas arredondadas
                                ),
                                clipBehavior: Clip
                                    .antiAlias, // Garante que a imagem respeite o arredondamento
                                child: Image.asset(
                                  'assets/viagem/nossa_frota_1.jpg',
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Container(
                                height: 250,
                                width: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Image.asset(
                                  'assets/viagem/nossa_frota_2.jpg',
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Container(
                                height: 250,
                                width: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Image.asset(
                                  'assets/viagem/nossa_frota_3.jpg',
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                height: 250,
                                width: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Image.asset(
                                  'assets/viagem/nossa_frota_4.jpg',
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Container(
                                height: 250,
                                width: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Image.asset(
                                  'assets/viagem/nossa_frota_5.jpg',
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  Widget buildNossaFrotaInterior() {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: 0,
                  left: largura > 1400 ? 300 : 100,
                  right: largura > 1400 ? 300 : 100,
                  bottom: 40),
              child: Column(
                children: [
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          espandirImagemInteriorNovaFrota =
                              !espandirImagemInteriorNovaFrota;
                        });
                      },
                      child: Container(
                        height: 75,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blueAccent),
                        ),
                        padding: EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Interior',
                              style: GoogleFonts.inter(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 0, 126, 180),
                              ),
                            ),
                            Icon(
                              espandirImagemInteriorNovaFrota
                                  ? Icons.remove
                                  : Icons.add,
                              color: Color.fromARGB(255, 0, 126, 180),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (espandirImagemInteriorNovaFrota) ...[
                    SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            height: 200,
                            width: 200,
                            child: Image.asset(
                              'assets/viagem/noss_frota_interior_1.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            height: 200,
                            width: 200,
                            child: Image.asset(
                              'assets/viagem/noss_frota_interior_2.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            height: 200,
                            width: 200,
                            child: Image.asset(
                              'assets/viagem/noss_frota_interior_3.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
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

  navegarParaTelaDeTelefoneDasAgencias() {
    Modular.to.navigate('/agencias');
  }

  navegarParaTelaDeMinhasCompras() {
    Modular.to.navigate('/compras');
  }

  navegarParaTelaDeMeusDados() {
    Modular.to.navigate('/dados');
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

  recuperarSenha(String email) {
    redefinirSenhaStore.recuperarSenha(RedefinirSenhaRequest(email: email));
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
