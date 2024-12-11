import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:montesBelos/core/utils/constants/configuracao.dart';
import 'package:montesBelos/core/utils/constants/constants.dart';
import 'package:montesBelos/core/utils/constants/strings.dart';
import 'package:montesBelos/features/data/models/cadastrar_usuario_request.dart';
import 'package:montesBelos/features/data/models/login_request.dart';
import 'package:montesBelos/features/data/models/purchase_request.dart';
import 'package:montesBelos/features/data/models/redefinir_senha_request.dart';
import 'package:montesBelos/features/domain/entities/novo_usuario_status.dart';
import 'package:montesBelos/features/presenter/components/dialog_carregamento_widget.dart';
import 'package:montesBelos/features/presenter/components/footer_widget.dart';
import 'package:montesBelos/features/presenter/components/snack_bar_personalizado_widget.dart';
import 'package:montesBelos/features/presenter/model/usuario.dart';
import 'package:montesBelos/features/presenter/pages/ida_page.dart';
import 'package:montesBelos/features/presenter/store/login_store.dart';
import 'package:montesBelos/features/presenter/store/novo_usuario_store.dart';
import 'package:montesBelos/features/presenter/store/purchase_request_store.dart';
import 'package:montesBelos/features/presenter/store/redefinir_senha_store.dart';
import 'package:montesBelos/features/presenter/utils/signIn_with_google.dart';
import 'package:montesBelos/features/presenter/utils/whats_app_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double largura = 0.0;

  bool _hoverIn1 = false;
  bool _hoverIn2 = false;

  bool _hoverIn4 = false;
  bool _hoverIn5 = false;

  PurchaseRequest? purchaseRequest;

  final LoginStore loginStore = Modular.get();
  var emailTextEditingController = TextEditingController(text: '');
  var redefinirEmailTextEditingController = TextEditingController(text: '');
  var senhaTextEditingController = TextEditingController(text: '');

  final NovoUsuarioStore novoUsuarioStore = Modular.get();
  final RedefinirSenhaStore redefinirSenhaStore = Modular.get();

  late Usuario usuario;

  var loginSocialGoogle = false;

  ClienteWeb? clienteWeb = ClienteWeb(id: 0);

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
                      buildAreaLogin(),
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
        } else {
          DialogDeCarregamento().esconderDialogDeCarregamento(context);
          mostrarSnackBarFalha(error.toString());
        }
      },
      onState: (ClienteWeb clienteWeb) {
        DialogDeCarregamento().esconderDialogDeCarregamento(context);
        mostrarSnackBarSucesso('Usuário logado com sucesso');
        PurchaseRequestStorage.saveClienteWeb(clienteWeb);
        purchaseRequest!.forwards == null
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

  verificarClienteWebJaLogado() {
    if (clienteWeb!.id != 0) {
      exibirDialogNavegarParaHome(context);
    }
  }

  Future<void> carregarClienteWeb() async {
    clienteWeb = (await PurchaseRequestStorage.getClienteWeb())!;
    verificarClienteWebJaLogado();
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
                  Text(
                    'Deseja prosseguir com sua compra ou começar uma nova?',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: const Color.fromARGB(255, 18, 45, 56),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      IdaPage.navigate(PurchaseRequest(), '', '');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Configuracao().COR_SECUNDARIA,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      'Continuar Compra',
                      style: GoogleFonts.inter(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      navegarParaTelaDeBusca();
                    },
                    child: Text(
                      'Ir para Home',
                      style: GoogleFonts.inter(
                        color: const Color.fromARGB(255, 18, 45, 56),
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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

  navegarParaTelaDeServicos() {
    Modular.to.navigate('/servicos');
  }

  Future<void> carregarPurchaseRequest() async {
    purchaseRequest = await PurchaseRequestStorage.getPurchaseRequest();
  }

  void navegarParaTelaDeBusca() {
    Modular.to.navigate('/');
  }

  navegarParaTelaDeNovoCadastro() {
    Modular.to.navigate('/novo_usuario');
  }

  navegarParaTelaDeFrota() {
    Modular.to.navigate('/frota');
  }

  navegarParaTelaDeTelefoneDasAgencias() {
    Modular.to.navigate('/agencias');
  }

  navegarParaTelaDeResumoDeCompra() {
    Modular.to.pushReplacementNamed('/pagamento');
  }

  Widget buildAreaLogin() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            Container(
              color: Configuracao().COR_PRINCIPAL,
              height: 250,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  SizedBox(
                    height: 75,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'INÍCIO ',
                        style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '/ ENTRAR ',
                        style: GoogleFonts.inter(
                            color: Color.fromARGB(255, 0, 69, 99),
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Entrar',
                    style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              height: 550,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [],
                ),
              ),
            ),
          ],
        ),
        Positioned(
            top: 180,
            child: Container(
              width: 400,
              height: 490,
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
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Acesse sua conta da Montes Belos',
                    style: GoogleFonts.inter(
                      color: Color.fromARGB(249, 0, 68, 97),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 45, right: 45),
                    child: GestureDetector(
                      onTap: () async {
                        Usuario user = await signInWithGoogle(context);

                        if (user.email != null) {
                          loginSocialGoogle = true;
                          carregarUsuario(user);
                          DialogDeCarregamento()
                              .exibirDialogDeCarregamento(context);

                          loginStore.realizarLogin(LoginRequest(
                              email: user.email,
                              senha: '',
                              idDaConta: user.id,
                              tipoDaConta: 1));
                        }
                      },
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 0, 102, 255),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Image.asset(
                                      'assets/home/icon_google.png',
                                      width: 18,
                                      height: 18,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      "CONTINUE COM GOOGLE",
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 30),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'ou',
                    style: GoogleFonts.inter(
                      color: Color.fromARGB(249, 0, 68, 97),
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 45, right: 45),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'E-mail',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(255, 56, 56, 56),
                          ),
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: emailTextEditingController,
                          decoration: InputDecoration(
                            hintText: 'Seu endereço de e-mail',
                            hintStyle: TextStyle(
                              color: const Color.fromARGB(179, 158, 158, 158),
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  color:
                                      const Color.fromARGB(179, 158, 158, 158)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Configuracao().COR_PRINCIPAL,
                              ), // cor da borda quando está em foco
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
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 45, right: 45),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Senha',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(255, 56, 56, 56),
                          ),
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: senhaTextEditingController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Sua senha',
                            hintStyle: TextStyle(
                              color: const Color.fromARGB(179, 158, 158, 158),
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  color: const Color.fromARGB(179, 158, 158,
                                      158)), // cor da borda quando não está em foco
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Configuracao().COR_PRINCIPAL,
                              ), // cor da borda quando está em foco
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
                  SizedBox(
                    height: 35,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 45, right: 45),
                    child: GestureDetector(
                      onTap: () {
                        if (emailTextEditingController.text != '' &&
                            senhaTextEditingController.text != '') {
                          loginStore.realizarLogin(LoginRequest(
                              email: emailTextEditingController.text
                                  .replaceAll(' ', ''),
                              senha: senhaTextEditingController.text,
                              idDaConta: '',
                              tipoDaConta: 0));
                          DialogDeCarregamento()
                              .exibirDialogDeCarregamento(context);
                          return;
                        }
                        mostrarSnackBarFalha('Email ou Senha inválidos');
                      },
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Container(
                          height: 45,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Configuracao().COR_SECUNDARIA,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 30),
                                      child: Text(
                                        "ENTRAR",
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 30),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Ainda não tem conta? ',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 112, 112, 112),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          navegarParaTelaDeNovoCadastro();
                        },
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Text(
                            'Faça seu cadastro',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 69, 99),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  GestureDetector(
                    onTap: () {
                      mostrarPopupRecuperarSenha();
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Text(
                        'Esqueceu sua senha?',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 0, 69, 99),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  carregarUsuario(Usuario user) {
    usuario = Usuario(
        email: user.email, id: user.id, nome: user.nome, tipoDaConta: 1);
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
                          size: 22,
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
                    child: ElevatedButton(
                      onPressed: () async {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.person_2_outlined,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Entrar',
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

  navegarParaTelaAnterior() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pop();
    });
  }

  navegarParaTelaDeComoComprar() {
    Modular.to.navigate('/como_comprar');
  }

  void navegarParaTelaFaleConosco() {
    Modular.to.navigate('/fale_conosco');
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
