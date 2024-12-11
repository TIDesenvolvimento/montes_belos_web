import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:montesBelos/core/utils/builder/correcao_de_texto.dart';
import 'package:montesBelos/core/utils/constants/configuracao.dart';
import 'package:montesBelos/core/utils/constants/constants.dart';
import 'package:montesBelos/features/data/models/atualizar_cliente_request.dart';
import 'package:montesBelos/features/data/models/purchase_request.dart';
import 'package:montesBelos/features/data/models/redefinir_senha_request.dart';
import 'package:montesBelos/features/presenter/components/dialog_carregamento_widget.dart';
import 'package:montesBelos/features/presenter/components/footer_widget.dart';
import 'package:montesBelos/features/presenter/components/snack_bar_personalizado_widget.dart';
import 'package:montesBelos/features/presenter/model/usuario.dart';
import 'package:montesBelos/features/presenter/store/atualizar_cliente_store.dart';
import 'package:montesBelos/features/presenter/store/login_store.dart';
import 'package:montesBelos/features/presenter/store/purchase_request_store.dart';
import 'package:montesBelos/features/presenter/store/redefinir_senha_store.dart';
import 'package:montesBelos/features/presenter/utils/whats_app_helper.dart';
import 'package:search_cep/search_cep.dart';
import 'package:url_launcher/url_launcher.dart';

class MeusDadosPage extends StatefulWidget {
  @override
  _MeusDadosPageState createState() => _MeusDadosPageState();
}

class _MeusDadosPageState extends State<MeusDadosPage> {
  double largura = 0.0;

  bool _hoverIn1 = false;
  bool _hoverIn2 = false;

  bool _hoverIn4 = false;
  bool _hoverIn5 = false;

  PurchaseRequest? purchaseRequest;

  final LoginStore loginStore = Modular.get();

  var cpfTextEditingController = TextEditingController(text: '');
  var rgTextEditingController = TextEditingController(text: '');
  var orgaoEmissorTextEditingController = TextEditingController(text: '');
  var nomeTextEditingController = TextEditingController(text: '');
  var telefoneTextEditingController = TextEditingController(text: '');
  var nascimentoTextEditingController = TextEditingController(text: '');
  var emailTextEditingController = TextEditingController(text: '');
  var cepTextEditingController = TextEditingController(text: '');
  var enderecoTextEditingController = TextEditingController(text: '');
  var complementoTextEditingController = TextEditingController(text: '');
  var cidadeTextEditingController = TextEditingController(text: '');
  var bairroTextEditingController = TextEditingController(text: '');
  final emailTextEditingControllerAPPLE = TextEditingController(text: '');

  final RedefinirSenhaStore redefinirSenhaStore = Modular.get();

  String? ufOrgaoEmissorSelecionada = null;
  String? ufEnderecoSelecionada = null;

  final AtualizarClienteStore atualizarClienteStore = Modular.get();

  late Usuario usuario;

  var loginSocialGoogle = false;

  late VoidCallback removerClienteStoreObserver;
  late VoidCallback removerRedefinirSenhaObserver;

  var redefinirEmailTextEditingController = TextEditingController(text: '');

  ClienteWeb? clienteWeb;

  var atualizarClienteRequest = AtualizarClienteResquest();

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
                      buildAreaDeinformacoes(),
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
    carregarClienteWebLocal();

    removerClienteStoreObserver =
        atualizarClienteStore.observer(onState: (state) {
      PurchaseRequestStorage.saveClienteWeb(clienteWeb!);
      DialogDeCarregamento().esconderDialogDeCarregamento(context);
      mostrarSnackBarSucesso('Dados atualizados com sucesso');
    }, onError: (error) {
      DialogDeCarregamento().esconderDialogDeCarregamento(context);
      mostrarSnackBarFalha(error.toString());
    });

    removerRedefinirSenhaObserver = redefinirSenhaStore.observer(
      onError: (error) {
        DialogDeCarregamento().esconderDialogDeCarregamento(context);
        mostrarSnackBarFalha(error.toString());
      },
      onState: (state) {
        DialogDeCarregamento().esconderDialogDeCarregamento(context);
        mostrarSnackBarSucesso('Senha alterada com sucesso');
      },
    );
  }

  @override
  void dispose() {
    removerClienteStoreObserver();
    removerRedefinirSenhaObserver();
    super.dispose();
  }

  Future<void> carregarPurchaseRequest() async {
    purchaseRequest = await PurchaseRequestStorage.getPurchaseRequest();
  }

  void navegarParaTelaDeBusca() {
    Modular.to.navigate('/');
  }

  void navegarParaTelaDeLogin() {
    Modular.to.navigate('/login');
  }

  Future<void> carregarClienteWebLocal() async {
    clienteWeb = ClienteWeb(id: 0);
    clienteWeb = (await PurchaseRequestStorage.getClienteWeb())!;
    setState(() {});
  }

  Widget buildAreaDeinformacoes() {
    final maskCpf = MaskTextInputFormatter(
        mask: "###.###.###-##", filter: {"#": RegExp(r'[0-9]')});
    final maskNascimento = MaskTextInputFormatter(
        mask: "##/##/####", filter: {"#": RegExp(r'[0-9]')});
    final maskTelefone = MaskTextInputFormatter(
        mask: "(##)#####-####", filter: {"#": RegExp(r'[0-9]')});

    if (clienteWeb != null && clienteWeb!.id != 0) {
      cpfTextEditingController =
          TextEditingController(text: clienteWeb!.cpf ?? '');
      rgTextEditingController =
          TextEditingController(text: clienteWeb!.rg ?? '');
      orgaoEmissorTextEditingController =
          TextEditingController(text: clienteWeb!.orgaoEmissorRg ?? '');
      nomeTextEditingController =
          TextEditingController(text: clienteWeb!.nome ?? '');
      telefoneTextEditingController =
          TextEditingController(text: clienteWeb!.fone ?? '');
      nascimentoTextEditingController =
          TextEditingController(text: clienteWeb!.dataNascimento ?? '');
      emailTextEditingController =
          TextEditingController(text: clienteWeb!.email ?? '');
      cepTextEditingController =
          TextEditingController(text: clienteWeb!.cep ?? '');
      enderecoTextEditingController =
          TextEditingController(text: clienteWeb!.logradouro ?? '');
      complementoTextEditingController =
          TextEditingController(text: clienteWeb!.complemento ?? '');
      cidadeTextEditingController =
          TextEditingController(text: clienteWeb!.localidade ?? '');
      bairroTextEditingController =
          TextEditingController(text: clienteWeb!.bairro ?? '');

      ufOrgaoEmissorSelecionada = clienteWeb!.ufRg ?? '';
      ufEnderecoSelecionada = clienteWeb!.uf ?? '';
    }

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
                        '/ MEUS DADOS ',
                        style: GoogleFonts.inter(
                            color: Configuracao().COR_SECUNDARIA,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Meus Dados',
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
              height: 850,
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
                    'Seus dados estão aqui',
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: cpfTextEditingController,
                          inputFormatters: [maskCpf],
                          decoration: InputDecoration(
                            labelText: 'CPF*',
                            labelStyle: TextStyle(
                              color: Color.fromARGB(255, 56, 56, 56),
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                            hintText: 'Seu CPF',
                            hintStyle: TextStyle(
                              color: const Color.fromARGB(179, 158, 158, 158),
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: const Color.fromARGB(179, 158, 158,
                                    158), // Cor da borda quando não está em foco
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 0, 155,
                                    221), // Cor da borda quando está em foco
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
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 45, right: 45),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: rgTextEditingController,
                          decoration: InputDecoration(
                            labelText: 'RG*',
                            labelStyle: TextStyle(
                              color: Color.fromARGB(255, 56, 56, 56),
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                            hintText: 'Seu RG',
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
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 45, right: 45),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3, // Proporção de 3/4
                          child: TextFormField(
                            controller: orgaoEmissorTextEditingController,
                            decoration: InputDecoration(
                              labelText: 'Orgão emissor*',
                              labelStyle: TextStyle(
                                color: Color.fromARGB(255, 56, 56, 56),
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: Color.fromARGB(179, 158, 158, 158),
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
                              color: Color.fromARGB(255, 56, 56, 56),
                            ),
                          ),
                        ),
                        SizedBox(width: 10), // Espaçamento entre os campos
                        Expanded(
                          flex: 1, // Proporção de 1/4
                          child: DropdownButtonFormField<String>(
                            value: ufOrgaoEmissorSelecionada,
                            onChanged: (String? value) {
                              ufOrgaoEmissorSelecionada = value.toString();
                            },
                            decoration: InputDecoration(
                              labelText: 'UF*',
                              labelStyle: TextStyle(
                                color: Color.fromARGB(255, 56, 56, 56),
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: Color.fromARGB(179, 158, 158, 158),
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
                              color: Color.fromARGB(255, 56, 56, 56),
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
                            validator: (value) => value == null
                                ? 'Por favor, selecione uma UF'
                                : null,
                          ),
                        ),
                      ],
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
                        TextFormField(
                          controller: nomeTextEditingController,
                          decoration: InputDecoration(
                            labelText: 'Nome completo*',
                            labelStyle: TextStyle(
                              color: Color.fromARGB(255, 56, 56, 56),
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Color.fromARGB(179, 158, 158, 158),
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
                            color: Color.fromARGB(255, 56, 56, 56),
                          ),
                        ),
                      ],
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
                        TextFormField(
                          inputFormatters: [maskTelefone],
                          controller: telefoneTextEditingController,
                          decoration: InputDecoration(
                            labelText: 'Telefone*',
                            labelStyle: TextStyle(
                              color: Color.fromARGB(255, 56, 56, 56),
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Color.fromARGB(179, 158, 158, 158),
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
                            color: Color.fromARGB(255, 56, 56, 56),
                          ),
                        ),
                      ],
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
                        TextFormField(
                          controller: nascimentoTextEditingController,
                          inputFormatters: [maskNascimento],
                          decoration: InputDecoration(
                            labelText: 'Data de nascimento*',
                            labelStyle: TextStyle(
                              color: Color.fromARGB(255, 56, 56, 56),
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Color.fromARGB(179, 158, 158, 158),
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
                            color: Color.fromARGB(255, 56, 56, 56),
                          ),
                        ),
                      ],
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
                        TextFormField(
                          controller: emailTextEditingController,
                          decoration: InputDecoration(
                            labelText: 'E-mail*',
                            labelStyle: TextStyle(
                              color: Color.fromARGB(255, 56, 56, 56),
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Color.fromARGB(179, 158, 158, 158),
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
                            color: Color.fromARGB(255, 56, 56, 56),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 45, right: 45),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3, // Proporção de 3/4
                          child: TextFormField(
                            controller: cepTextEditingController,
                            onChanged: (value) async {
                              if (value.length == 8) {
                                buscarCep(value);
                              }
                            },
                            decoration: InputDecoration(
                              labelText: 'Cep*',
                              labelStyle: TextStyle(
                                color: Color.fromARGB(255, 56, 56, 56),
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: Color.fromARGB(179, 158, 158, 158),
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
                              color: Color.fromARGB(255, 56, 56, 56),
                            ),
                          ),
                        ),
                        SizedBox(width: 10), // Espaçamento entre os campos
                        Expanded(
                          flex: 1, // Proporção de 1/4
                          child: DropdownButtonFormField<String>(
                            value: ufEnderecoSelecionada,
                            decoration: InputDecoration(
                              labelText: 'UF*',
                              labelStyle: TextStyle(
                                color: Color.fromARGB(255, 56, 56, 56),
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: Color.fromARGB(179, 158, 158, 158),
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
                              color: Color.fromARGB(255, 56, 56, 56),
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
                            onChanged: (String? value) {
                              ufEnderecoSelecionada = value.toString();
                            },
                            validator: (value) => value == null
                                ? 'Por favor, selecione uma UF'
                                : null,
                          ),
                        ),
                      ],
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
                        TextFormField(
                          controller: enderecoTextEditingController,
                          decoration: InputDecoration(
                            labelText: 'Endereço*',
                            labelStyle: TextStyle(
                              color: Color.fromARGB(255, 56, 56, 56),
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Color.fromARGB(179, 158, 158, 158),
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
                            color: Color.fromARGB(255, 56, 56, 56),
                          ),
                        ),
                      ],
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
                        TextFormField(
                          controller: complementoTextEditingController,
                          decoration: InputDecoration(
                            labelText: 'Complemento*',
                            labelStyle: TextStyle(
                              color: Color.fromARGB(255, 56, 56, 56),
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Color.fromARGB(179, 158, 158, 158),
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
                            color: Color.fromARGB(255, 56, 56, 56),
                          ),
                        ),
                      ],
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
                        TextFormField(
                          controller: cidadeTextEditingController,
                          decoration: InputDecoration(
                            labelText: 'Cidade*',
                            labelStyle: TextStyle(
                              color: Color.fromARGB(255, 56, 56, 56),
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Color.fromARGB(179, 158, 158, 158),
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
                            color: Color.fromARGB(255, 56, 56, 56),
                          ),
                        ),
                      ],
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
                        TextFormField(
                          controller: bairroTextEditingController,
                          decoration: InputDecoration(
                            labelText: 'Bairro*',
                            labelStyle: TextStyle(
                              color: Color.fromARGB(255, 56, 56, 56),
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Color.fromARGB(179, 158, 158, 158),
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
                        if (ufEnderecoSelecionada != null &&
                            ufOrgaoEmissorSelecionada != null &&
                            validarCamposPreenchidos()) {
                          DialogDeCarregamento()
                              .exibirDialogDeCarregamento(context);
                          carregarClienteWeb(ufOrgaoEmissorSelecionada!,
                              ufEnderecoSelecionada!);
                          carregarClienteRequest();
                          atualizarClienteStore
                              .atualizarCliente(atualizarClienteRequest);
                          return;
                        }
                        mostrarSnackBarFalha(
                            'Todos os campos devem ser preenchidos');
                      },
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Container(
                          height: 45,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Configuracao().COR_PRINCIPAL,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(
                              "ATUALIZAR DADOS",
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
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
                        'Quero redefinir minha senha',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 0, 69, 99),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Future<void> buscarCep(String cep) async {
    final viaCepSearchCep = ViaCepSearchCep();
    final result = await viaCepSearchCep.searchInfoByCep(cep: cep);

    result.fold(
      (error) {},
      (infoCep) {
        enderecoTextEditingController.text = infoCep.logradouro ?? '';
        cidadeTextEditingController.text = infoCep.localidade ?? '';
        bairroTextEditingController.text = infoCep.bairro ?? '';
        ufEnderecoSelecionada = infoCep.uf;
        setState(() {});
      },
    );
  }

  carregarClienteRequest() {
    atualizarClienteRequest = AtualizarClienteResquest(
        id: clienteWeb!.id,
        cpf: clienteWeb!.cpf,
        tipoPessoa: clienteWeb!.tipoPessoa,
        concordaTermos: clienteWeb!.concordaTermos == false ? false : true,
        dataCadastro: clienteWeb!.dataCadastro,
        cnpj: clienteWeb!.cnpj,
        email: clienteWeb!.email,
        ativo: clienteWeb!.ativo == false ? false : true,
        origem: clienteWeb!.origem,
        umaskedFone: clienteWeb!.umaskedFone,
        rg: clienteWeb!.rg,
        orgaoEmissorRg: clienteWeb!.orgaoEmissorRg,
        ufRg: clienteWeb!.ufRg,
        nome: clienteWeb!.nome,
        fone: clienteWeb!.fone,
        dataNascimento: clienteWeb!.dataNascimento,
        cep: clienteWeb!.cep,
        logradouro: clienteWeb!.logradouro,
        complemento: clienteWeb!.complemento,
        uf: clienteWeb!.uf,
        tokenAtivacao: clienteWeb!.tokenAtivacao,
        localidade: clienteWeb!.localidade,
        bairro: clienteWeb!.bairro,
        senha: clienteWeb!.senha,
        tokenClienteWeb: clienteWeb!.tokenClienteWeb);
  }

  carregarClienteWeb(String ufOrgaoEmissorSelecionada, String ufEndereco) {
    clienteWeb!.cpf = cpfTextEditingController.text;
    clienteWeb!.rg = rgTextEditingController.text;
    clienteWeb!.orgaoEmissorRg = orgaoEmissorTextEditingController.text;
    clienteWeb!.ufRg = ufOrgaoEmissorSelecionada;
    clienteWeb!.nome = CorrecaoDeTexto()
        .getNomeDosTrechosCorrigidos(nomeTextEditingController.text.trim());
    clienteWeb!.fone = telefoneTextEditingController.text;
    clienteWeb!.umaskedFone = telefoneTextEditingController.text;
    clienteWeb!.dataNascimento = nascimentoTextEditingController.text;
    clienteWeb!.cep = cepTextEditingController.text;
    clienteWeb!.logradouro = enderecoTextEditingController.text;
    clienteWeb!.complemento = complementoTextEditingController.text;
    clienteWeb!.uf = ufEndereco;
    clienteWeb!.localidade = cidadeTextEditingController.text;
    clienteWeb!.bairro = bairroTextEditingController.text;
    clienteWeb!.ativo = true;
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

  recuperarSenha(String email) {
    redefinirSenhaStore.recuperarSenha(RedefinirSenhaRequest(email: email));
  }

  navegarParaTelaDeServicos() {
    Modular.to.navigate('/servicos');
  }

  navegarParaTelaDeFrota() {
    Modular.to.navigate('/frota');
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
            bottom: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: navegarParaTelaDeBusca,
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
                          borderRadius: BorderRadius.circular(12),
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
                        if (clienteWeb == null) {
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
                                clienteWeb == null ? 'Entrar' : 'Conta',
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

  navegarParaTelaDeComoComprar() {
    Modular.to.navigate('/como_comprar');
  }

  Future<void> direcionarParaOWhatsapp() async {
    if (!await launchUrl(
        Uri.parse(
            'https://wa.me/5561974033015?text=Ol%C3%A1,%20estou%20vindo%20do%20site%20da%20Expresso%20JK%20e%20quero%20comprar%20passagem.'),
        mode: LaunchMode.externalApplication)) {}
  }

  bool validarCamposPreenchidos() {
    return cpfTextEditingController.text.isNotEmpty &&
        rgTextEditingController.text.isNotEmpty &&
        orgaoEmissorTextEditingController.text.isNotEmpty &&
        nomeTextEditingController.text.isNotEmpty &&
        telefoneTextEditingController.text.isNotEmpty &&
        nascimentoTextEditingController.text.isNotEmpty &&
        emailTextEditingController.text.isNotEmpty &&
        cepTextEditingController.text.isNotEmpty &&
        enderecoTextEditingController.text.isNotEmpty &&
        complementoTextEditingController.text.isNotEmpty &&
        cidadeTextEditingController.text.isNotEmpty &&
        bairroTextEditingController.text.isNotEmpty;
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
    carregarClienteWebLocal();
  }

  navegarParaTelaDeTelefoneDasAgencias() {
    Modular.to.navigate('/agencias');
  }

  navegarParaTelaDeNovoCadastro() {
    Modular.to.navigate('/novo_usuario');
  }

  navegarParaTelaDeMinhasCompras() {
    Modular.to.navigate('/compras');
  }

  navegarParaTelaDeMeusDados() {
    Modular.to.navigate('/dados');
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
