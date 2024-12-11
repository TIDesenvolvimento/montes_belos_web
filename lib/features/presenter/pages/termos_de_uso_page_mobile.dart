import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:montesBelos/core/utils/constants/configuracao.dart';
import 'package:montesBelos/core/utils/constants/constants.dart';
import 'package:montesBelos/features/data/models/get_telefone_das_agencias_response.dart';
import 'package:montesBelos/features/data/models/purchase_request.dart';
import 'package:montesBelos/features/presenter/components/dialog_carregamento_widget.dart';
import 'package:montesBelos/features/presenter/components/drawer_widget_mobile.dart';
import 'package:montesBelos/features/presenter/components/footer_widget_mobile.dart';
import 'package:montesBelos/features/presenter/components/snack_bar_personalizado_widget.dart';
import 'package:montesBelos/features/presenter/model/usuario.dart';
import 'package:montesBelos/features/presenter/store/get_telefone_das_agencias_store.dart';
import 'package:montesBelos/features/presenter/store/login_store.dart';
import 'package:montesBelos/features/presenter/store/purchase_request_store.dart';

class TermosDeUsoPageMobile extends StatefulWidget {
  @override
  _TermosDeUsoPageMobileState createState() => _TermosDeUsoPageMobileState();
}

class _TermosDeUsoPageMobileState extends State<TermosDeUsoPageMobile> {
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
        endDrawer: DrawerMobile(clienteWeb: clienteWeb),
        backgroundColor: Colors.white,
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

  Future<void> carregarClienteWeb() async {
    clienteWeb = (await PurchaseRequestStorage.getClienteWeb())!;
    setState(() {});
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
            child: Column(
              children: [buildWigetPrimeirosTermosDeUso(), FooterMobile()],
            ),
          ),
        );
      },
    );
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

  Widget buildWigetPrimeirosTermosDeUso() {
    return Padding(
      padding: EdgeInsets.only(
        top: 0,
        left: 20,
        right: 20,
        bottom: 25,
      ),
      child: Container(
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
                  '/ TERMOS E CONDIÇÕES DE USO ',
                  style: GoogleFonts.inter(
                      color: Configuracao().COR_PRINCIPAL,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            SizedBox(height: 30),
            Text(
              'Termos e condições de uso',
              style: GoogleFonts.inter(
                  color: Configuracao().COR_PRINCIPAL,
                  fontSize: 30,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 15),
            Text(
              'Este Termo de Uso apresenta as “Condições Gerais” aplicáveis ao uso dos serviços oferecidos pela VIACAO MONTES BELOS LTDA, inscrita no CNPJ sob n.º 01813824000143, com sede na RUA 601, QUADRA 530 LOTE 07, SETOR SAO JOSE N 53 CEP 74440460, doravante denominada “VIACAO MONTES BELOS" o qual inclui o agendamento de passagens de ônibus e outros serviços relacionados a viagens, através do site COLOQUE O SITE. Este termo está estritamente validado conforme o código de defesa do consumidor (Lei 8.078/90) e o Decreto 7.962/2013. Qualquer pessoa, legalmente capaz, denominada “CLIENTE”, que utilize os serviços da “VIACAO MONTES BELOS", deve aceitar este Termo de Utilização e todas as políticas e princípios que o regem. O TERMO DE UTILIZAÇÃO É INDISPENSÁVEL, sendo obrigatório para a UTILIZAÇÃO dos serviços deste Website. A utilização dos serviços oferecidos pela “VIACAO MONTES BELOS" implica na imediata aquiescência/ anuência deste Termo e seu conteúdo. Este acordo constitui-se em documento exclusivo entre “VIACAO MONTES BELOS" e o “CLIENTE”, substituindo-se, deste modo, todos os acordos, representações, garantias e entendimentos anteriores com relação a “VIACAO MONTES BELOS", seus conteúdos e serviços fornecidos por ou através deste Website. Caso deseje se cadastrar, acessar e utilizar as demais páginas ou recursos deste Website, leia atentamente as condições abaixo e confirme sua anuência clicando no campo “Concordo”, localizado ao final. ATENÇÃO: O “CLIENTE” MENOR DE 18 ANOS DE IDADE SOMENTE PODERÁ EFETUAR O REGISTRO OU CADASTRO NESTE WEBSITE DESDE QUE DEVIDAMENTE REPRESENTADO OU ASSISTIDO, CONFORME PREVISTO NOS ARTS. 1.634 E 1.690 DO CÓDIGO CIVIL, POR SEUS REPRESENTANTES OU ASSISTENTES LEGAIS, DEVENDO ESSES SER RESPONSÁVEIS NA ESFERA CÍVEL POR TODO E QUALQUER ATO PRATICADO PELO MENOR QUANDO DA UTILIZAÇÃO DO WEBSITE. “CLIENTE” MENOR DE 12 ANOS PODERÁ VIAJAR ACOMPANHADO DO SEU RESPONSÁVEL LEGAL DESDE QUE APRESENTE AUTORIZAÇÃO POR ESCRITO (REGISTRADA EM CARTÓRIO) DOS PAIS, RESPONSÁVEIS OU TUTORES, EXPEDIDO PELO JUÍZO DA INFÂNCIA E JUVENTUDE. É OBRIGATÓRIA SOMENTE NOS SEGUINTES CASOS: 1 – QUANDO A CRIANÇA, OU SEJA, MENOR DE 12 ANOS, VIAJAR PARA FORA DA COMARCA ONDE RESIDE, DESACOMPANHADA DOS PAIS, DE GUARDIÃO OU DE TUTOR, DE PARENTE OU DE PESSOA AUTORIZADA POR ESCRITO, COM FIRMA RECONHECIDA (PELOS PAIS, PELO GUARDIÃO OU PELO TUTOR). 2 – QUANDO UM DOS GENITORES ESTÁ IMPOSSIBILITADO DE DAR A AUTORIZAÇÃO, POR RAZÕES COMO VIAGEM, DOENÇA OU PARADEIRO IGNORADO, EM CASO DE VIAGEM AO EXTERIOR. 3 – QUANDO A CRIANÇA OU ADOLESCENTE NASCIDO EM TERRITÓRIO NACIONAL VIAJAR PARA O EXTERIOR EM COMPANHIA DE ESTRANGEIRO RESIDENTE OU DOMICILIADO NO EXTERIOR. O “CLIENTE” MAIOR DE 12 ANOS PODERÁ VIAJAR SOZINHO DESDE QUE DEVIDAMENTE ACOMPANHADO COM OS DOCUMENTOS DE IDENTIFICAÇÃO.',
              textAlign: TextAlign.justify,
              style: GoogleFonts.inter(
                color: Color.fromARGB(255, 50, 50, 50),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 30),
            Text(
              '1° - CONSIDERANDO QUE',
              style: GoogleFonts.inter(
                  color: Configuracao().COR_PRINCIPAL,
                  fontSize: 26,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 15),
            Text(
              '1. Ao clicar em “Prosseguir Compra” no site da “VIACAO MONTES BELOS" automaticamente concorda com os Termos e Condições de Uso aqui explícitos. Caso o “CLIENTE” não esteja de acordo com os Termos e Condições de Uso, não deverá efetuar nenhum tipo de compra no Website.\n'
              '2. A “VIACAO MONTES BELOS" não garante que seu conteúdo seja apropriado ou esteja disponível para uso em outras localidades fora do território brasileiro; também se isenta de responsabilidades pelo acesso ao Website a partir de territórios onde seu conteúdo seja ilegal, recaindo inteiramente o ônus de utilização sobre o “CLIENTE”.\n'
              '3. Desta maneira ao optar pelo acesso a “VIACAO MONTES BELOS" o “CLIENTE” compreende, reconhece e concorda que sua utilização é regida pelo ordenamento jurídico da República Federativa do Brasil em relação à conduta online e conteúdo disponibilizado. As informações sobre os serviços estarão organizadas no website de forma clara, precisa e em português, fazendo constar todas as informações referentes aos tipos de passagens e reservas disponíveis.\n'
              '4. O uso deste Website restringe-se ao privado, sendo vedada sua utilização comercial com fins lucrativos por terceiros não autorizados; bem como também é proibido, e protegido pela legislação competente, o uso de qualquer software ou sistema automatizado para extrair dados deste Website para a exibição em qualquer outro lugar do mundo sem o consentimento expresso de seus proprietários.\n'
              '5. A “VIACAO MONTES BELOS" isenta-se da responsabilidade por qualquer erro ou atraso na remoção de conteúdo impreciso, ilícito ou censurável proveniente ou fornecido por terceiros através de nosso Website. A equipe da “VIACAO MONTES BELOS" pode mudar, a qualquer tempo e sem aviso prévio, o conteúdo e funcionalidades do Website.\n'
              '6. A aquisição do(s) serviço(s) pelo “CLIENTE” será finalizada e concluída, após o devido pagamento que se dará através da prestação de serviço de empresa responsável por gestão de pagamentos (PagSeguro). A “VIACAO MONTES BELOS" não poderá intervir nos resultados da relação do “CLIENTE” com a empresa responsável por gestão de pagamentos (PagSeguro), uma vez que a mesma administra suas operações de forma independente.\n'
              '7. A “VIACAO MONTES BELOS" não pode garantir de forma alguma que os serviços prestados pela empresa responsável pela gestão de pagamentos funcionarão livres de erros, interrupções, mau funcionamento, atrasos ou outras imperfeições. Ressalte-se que não será responsável pela disponibilidade ou não dos Serviços prestados pela empresa responsável pela gestão de pagamentos ou pela impossibilidade do uso do Serviço.\n'
              '8. A “VIACAO MONTES BELOS" poderá, a qualquer tempo, alterar o presente instrumento visando o aprimoramento, bem como a melhoria dos serviços prestados. O novo instrumento contratual entrará em vigor, sem prejuízo dos serviços veiculados na vigência do contrato anterior. Assim, a “VIACAO MONTES BELOS" recomenda que o “CLIENTE” tenha o costume de reler atentamente os termos e condições de uso sempre que acessar o Website ou realizar qualquer operação por meio deste.\n'
              '9. A “VIACAO MONTES BELOS" tomará todas as medidas possíveis para manter a confidencialidade, segurança e sigilo às informações dos “CLIENTES”, porém não responderá por prejuízo que possa ser derivado da violação dessas medidas por parte de terceiros que utilizem as redes públicas ou a internet, subvertendo os sistemas de segurança para acessar as informações de “CLIENTES”.\n'
              '10. Com efeito, preocupada com a segurança e privacidade dos dados que trafegam no Website, a “VIACAO MONTES BELOS" declara que a senha de acesso e todos os dados que o “CLIENTE” digitar na página do Website são protegidos. A “VIACAO MONTES BELOS" recomenda que o “CLIENTE” nunca forneça sua senha a terceiros. O “CLIENTE” é integralmente responsável pelo sigilo e utilização de sua senha, identidade e privacidade no uso de seu e-mail.\n'
              '11. A “VIACAO MONTES BELOS" não será responsável por qualquer dano, prejuízo ou perda no equipamento do “CLIENTE” causado por falhas no sistema, no servidor ou na internet decorrentes de condutas de terceiros, ressalvado que eventualmente, o sistema poderá não estar disponível por motivos técnicos ou falhas da internet, ou por qualquer outro evento fortuito ou de força maior alheio ao seu controle.\n'
              '12. Conforme legislação protetiva do Código de Defesa do Consumidor e a legislação específica da ANTT é assegurado ao “CLIENTE” o direito de arrependimento, desde que este ocorra no prazo de 48 horas (quarenta e oito horas), antes da realização da viagem, ressalvados os casos em que o serviço apresente alguma informação incorreta de culpa exclusiva da “VIACAO MONTES BELOS", o que autoriza o “CLIENTE” a desfazer o negócio com a “VIACAO MONTES BELOS".',
              style: GoogleFonts.inter(
                color: Configuracao().COR_SECUNDARIA,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 30),
            Text(
              '2 ° - OBJETO DO CONTRATO',
              style: GoogleFonts.inter(
                  color: Configuracao().COR_PRINCIPAL,
                  fontSize: 26,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 15),
            Text(
              '1. Constitui objeto deste contrato a facilitação, através de ferramenta própria da “VIACAO MONTES BELOS" nas compras de passagens rodoviárias pelos “CLIENTES”.\n'
              '2. Das Informações para utilização dos Serviços: Do Cadastro do Cliente: Não é condição essencial o cadastro do “CLIENTE” para consulta de trechos e horários. O “CLIENTE” poderá se cadastrar e aproveitar as condições diferenciadas para cadastrados neste Website. O cadastro será confirmado após o correto e completo preenchimento de todos os dados solicitados.\n'
              '3. Não será permitido ao “CLIENTE” ter mais de um cadastro e, caso isso ocorra, a “VIACAO MONTES BELOS" desabilitará, automaticamente, após verificação dos dados, definitivamente todos os cadastros.\n'
              '4. Todo e qualquer “CLIENTE” menor de 18 anos deverá obter o consentimento expresso de seus pais ou representantes legais antes de fornecer os seus endereços de e-mail ou quaisquer dados a “VIACAO MONTES BELOS" por meio deste Website. Todas as informações fornecidas pelo “CLIENTE” devem ser exatas, precisas e verdadeiras, e devidamente atualizadas, caso ocorra qualquer alteração, reconhecendo o “CLIENTE”, ainda, que a “VIACAO MONTES BELOS" não tem a obrigação de verificar a precisão dos dados transmitidos pelo “CLIENTE” ou qualquer outra pessoa.\n'
              '5. Diante disso, a “VIACAO MONTES BELOS" não se responsabilizará pela correção de dados pessoais inseridos pelo “CLIENTE”, sendo certo que o “CLIENTE” ou seus pais ou representantes legais, quando for o caso - garante e responde, em qualquer caso, pela veracidade, precisão e autenticidade dos dados pessoais cadastrados.\n'
              '6. A “VIACAO MONTES BELOS" se compromete a não ceder ou comercializar, sob nenhuma forma, informações individuais do “CLIENTE” cadastrado sem a sua expressa autorização. Entretanto, o “CLIENTE” acorda que a Internet, enquanto rede mundial de computadores a qual qualquer pessoa pode ter acesso, não é um meio totalmente seguro. No caso de utilização do Website, a “VIACAO MONTES BELOS" não se responsabilizará em nenhuma hipótese por prejuízos de qualquer espécie, inclusive, mas sem limitação, àqueles decorrentes do uso de tais dados por terceiros ou extravio de dados do “CLIENTE” cadastrado, decorrentes direta ou indiretamente do seu acesso ou navegação no Website.\n'
              '7. A “VIACAO MONTES BELOS" a seu critério exclusivo e absoluto, pode alterar os critérios de qualificação e/ou exigências para a manutenção do cadastrado no Website. Deste modo, a “VIACAO MONTES BELOS" poderá imediatamente encerrar o registro do cadastrado no Website, independentemente do pagamento de multa e/ou indenização, a qualquer título, ao “CLIENTE”, externando posteriormente a justificativa ou motivos.\n'
              '8. Fica ressalvado o direito do “CLIENTE” em retificar quaisquer dados enviados a “VIACAO MONTES BELOS". Entretanto, o direito de retificação do “CLIENTE” não obstará ou substituirá o direito da “VIACAO MONTES BELOS" em pleitear as indenizações cabíveis, no caso de informações errôneas ensejarem quaisquer danos e/ou prejuízos a “VIACAO MONTES BELOS" ou a terceiros, no período anterior à sua retificação pelo “CLIENTE”.',
              style: GoogleFonts.inter(
                color: Configuracao().COR_SECUNDARIA,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 30),
            Text(
              '3 ° - DOS PASSOS PARA A COMPRA DA PASSAGEM',
              style: GoogleFonts.inter(
                  color: Configuracao().COR_PRINCIPAL,
                  fontSize: 26,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 15),
            Text(
              '1. Para efetuar a compra de sua viagem através da “VIACAO MONTES BELOS" basta seguir os passos asseguir e para visualizar o status de compra em acesse Minha Conta. Das informações preliminares: Inicialmente basta preencher os campos origem, destino e data de viagem, sem a necessidade de cadastro prévio. Após o preenchimento dos dados iniciais, o “CLIENTE” deverá optar por uma das Viações para o trecho desejado conforme horário e valores disponiveis no momento da compra.\n'
              '2. Da reserva de assentos: O “CLIENTE” poderá reservar seu assento através do Website da “VIACAO MONTES BELOS", porém a “VIACAO MONTES BELOS" não se responsabiliza pela incorreção dos dados inseridos na reserva de assentos. Os “CLIENTES” estão cientes da veracidade, exatidão e autenticidade dos dados pessoais cadastrados. As poltronas somente são reservadas quando o pagamento é concluído, caso não seja efetuado o pagamento, a passagem será liberada para venda novamente e o assento poderá ser reservado por outro “CLIENTE”.\n'
              '3. A passagem deve estar em nome do passageiro que irá viajar para que este, em posse de seu documento, possa retirar no guichê da “VIACAO MONTES BELOS"\n'
              '4. Do preenchimento dos dados do passageiro: O “CLIENTE” deverá preencher seus dados corretamente para emissão da passagem, para validação da compra pela operadora de cartão, pela equipe interna da “VIACAO MONTES BELOS" e pela equipe antifraude.\n'
              '5. A “VIACAO MONTES BELOS" não se responsabiliza pelo preenchimento incorreto das informações requeridas, bem como pela não aprovação do “CLIENTE” após avaliação das documentações solicitadas.',
              style: GoogleFonts.inter(
                color: Configuracao().COR_SECUNDARIA,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 30),
            Text(
              '4° - TAXAS E FORMAS DE PAGAMENTO',
              style: GoogleFonts.inter(
                  color: Configuracao().COR_PRINCIPAL,
                  fontSize: 26,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 15),
            Text(
              '1. Da cobrança da taxa de conveniência: Para a prestação de serviço de facilitação na compra de passagens de ônibus, a “VIACAO MONTES BELOS" cobrará uma taxa de conveniência. A taxa de conveniência estará discriminada no ato da compra.\n'
              '2. Todas as transações realizadas possuem a adição de taxas cobradas pela auto viação “VIACAO MONTES BELOS".\n'
              '3. As taxas cobradas pelas Auto Viações são: Pedágio, Impostos. Estas variam de acordo com cada companhia e trajeto.\n'
              '4. A taxa de conveniência cobrada pela “VIACAO MONTES BELOS", no momento da compra da passagem, pela prestação do serviço, não será devolvida ao “CLIENTE” em caso de cancelamento da passagem por se tratar de prestação de serviço já realizada ao “CLIENTE”.\n'
              '5. Das formas de pagamento: Cartão de crédito: A “VIACAO MONTES BELOS" aceita as principais bandeiras de cartão de crédito através do sistema PagSeguro: A “VIACAO MONTES BELOS" cobrará a fatura no seu cartão de crédito imediatamente após o recebimento do pedido. Cartão de Débito: Através do sistema PagSeguro\n'
              'IMPORTANTE: TODAS AS TAXAS SERÃO INFORMADAS E DISCRIMINADAS NA TELA DE CONCLUSÃO DE COMPRA, AO CLICAR NO BOTÃO DE CONCLUSÃO O CLIENTE DECLARA-SE CIENTE DOS VALORES COBRADOS E NÃO PODERÁ QUESTIONÁ-LOS. A “VIACAO MONTES BELOS" SE RESERVA NO DIREITO DE EXCLUIR QUALQUER MEIO DE PAGAMENTO E DE USAR OUTROS MEIOS DE PAGAMENTOS EXISTENTES NO MERCADO.',
              style: GoogleFonts.inter(
                color: Configuracao().COR_SECUNDARIA,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 30),
            Text(
              '5 ° - PROCESSO DE APROVAÇÃO',
              style: GoogleFonts.inter(
                  color: Configuracao().COR_PRINCIPAL,
                  fontSize: 26,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 15),
            Text(
              '1. Todas as transações efetuadas passarão por análise e aprovação interna. Após o processo de análise, o “CLIENTE” receberá em seu e-mail a informação de conclusão do processo contendo o Voucher para retirada da passagem no guichê da Viação “VIACAO MONTES BELOS", caso a aprovação seja confirmada. Caso não encontre, verifique sua caixa de SPAM e/ou Lixo Eletrônico.\n'
              '2. A “VIACAO MONTES BELOS" não pode garantir de forma nenhuma que os serviços prestados pela empresa responsável pela gestão de pagamentos funcionarão livres de erros, interrupções, maus funcionamentos, atrasos ou outras imperfeições.\n'
              '3. Para mais informações sobre sua compra e status do pedido acesse o site acesse no campo Minha Conta / Minha Compra.',
              style: GoogleFonts.inter(
                color: Configuracao().COR_SECUNDARIA,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 30),
            Text(
              '6° - COMPRAS PENDENTES DE ANÁLISE',
              style: GoogleFonts.inter(
                  color: Configuracao().COR_PRINCIPAL,
                  fontSize: 26,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 15),
            Text(
              '1. Dependendo do histórico do cartão de crédito e seu titular ou a inserção de dados de compra divergentes, a transação poderá entrar em um processo de análise mais minucioso. Quando o processo for finalizado, o “CLIENTE” receberá um e-mail de confirmação com o Voucher ou a informação de não aprovação da transação.',
              style: GoogleFonts.inter(
                color: Configuracao().COR_SECUNDARIA,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 30),
            Text(
              '7° - COMPRAS NÃO APROVADAS',
              style: GoogleFonts.inter(
                  color: Configuracao().COR_PRINCIPAL,
                  fontSize: 26,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 15),
            Text(
              '1. A compra não aprovada pelo sistema interno da “VIACAO MONTES BELOS" através de informações ou processos cedidos pela operadora de cartão de crédito (por políticas internas que a “VIACAO MONTES BELOS" não divulga), será automaticamente cancelada e a informação de não aprovação estará disponibilizada na página Minha Conta/Minha Compra.',
              style: GoogleFonts.inter(
                color: Configuracao().COR_SECUNDARIA,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 30),
            Text(
              '8° - COMPRAS NÃO FINALIZADAS',
              style: GoogleFonts.inter(
                  color: Configuracao().COR_PRINCIPAL,
                  fontSize: 26,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 15),
            Text(
              '1. Caso o cliente não termine o processo de compra, esta não será concretizada, os valores da transação não serão debitados/creditados e os assentos selecionados não estarão reservados.',
              style: GoogleFonts.inter(
                color: Configuracao().COR_SECUNDARIA,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 30),
            Text(
              '9° - DA IMPRESSÃO DO BILHETE RODOVIÀRIO',
              style: GoogleFonts.inter(
                  color: Configuracao().COR_PRINCIPAL,
                  fontSize: 26,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 15),
            Text(
              '1. Concluindo à compra o “CLIENTE” receberá um e-mail com a confirmação do pagamento, resumo do pedido e voucher contendo os detalhes sobre a viagem.',
              style: GoogleFonts.inter(
                color: Configuracao().COR_SECUNDARIA,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              '2. Para impressão do seu bilhete compareça ao guichê da Auto Viação “VIACAO MONTES BELOS" com 1 (uma) hora de antecedência ao horário de embarque, munido de documento original com foto preenchido na reserva de assentos e voucher da compra. Cópias autenticadas não serão aceitas.',
              style: GoogleFonts.inter(
                color: Configuracao().COR_SECUNDARIA,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 30),
            Text(
              '10° - ALTERAÇÕES E CANCELAMENTOS DAS PASSAGENS',
              style: GoogleFonts.inter(
                  color: Configuracao().COR_PRINCIPAL,
                  fontSize: 26,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 15),
            Text(
              '1. Fica assegurado ao “CLIENTE” solicitar a alteração da data ou horário de embarque, diretamente ao guichê da Auto Viação “VIACAO MONTES BELOS", por telefone ou presencialmente com antecedência mínima de 5 (cinco) horas do horário estabelecido para embarque.',
              style: GoogleFonts.inter(
                color: Configuracao().COR_SECUNDARIA,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              '2. A transferência de horário ficará condicionada à disponibilidade de passagens na data e horário desejado pelo “CLIENTE”, ficando ainda assegurada ao “CLIENTE” a opção pela passagem com data e horário em aberto, com validade máxima de 12 (doze) meses, contados da data de compra do bilhete original, ficando sujeita a reajuste de preço. Entre em contato diretamente com a viação “VIACAO MONTES BELOS", por telefone ou através do guichê dentro do terminal rodoviário.',
              style: GoogleFonts.inter(
                color: Configuracao().COR_SECUNDARIA,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              '3. O cancelamento da compra deverá ser realizado no site na aba de cancelamentos ou no guichê da Viação “VIACAO MONTES BELOS", por sua viagem e precisa ser solicitado até 3 (três) horas de antecedência da sua viagem.',
              style: GoogleFonts.inter(
                color: Configuracao().COR_SECUNDARIA,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              '4. O “CLIENTE” tem um prazo de 7 (sete) dias, a partir da compra da passagem, para entrar em contato com a Viação “VIACAO MONTES BELOS" responsável pela passagem e utilizar o direito de arrependimento previsto no artigo 49 da lei 8.078/90. Porém, se o prazo para a viagem for menor que os 7 (sete) dias da data da compra deve-se comunicar a Viação com antecedência mínima de 5 (cinco) horas ao embarque agendado.',
              style: GoogleFonts.inter(
                color: Configuracao().COR_SECUNDARIA,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 30),
            Text(
              '11° - REEMBOLSO DA PASSAGEM',
              style: GoogleFonts.inter(
                  color: Configuracao().COR_PRINCIPAL,
                  fontSize: 26,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 15),
            Text(
              '1. Cartão de crédito: A devolução do valor será de acordo com repasse da administradora da bandeira. O valor será creditado no próximo vencimento da fatura do “CLIENTE”, podendo ocorrer de 30 (trinta) a 60 (sessenta) dias.\n\n'
              '2. Cartão de Débito: O “CLIENTE” deverá entrar em contato com a “VIACAO MONTES BELOS" através do Telefone: 062995415091 e informar seus dados bancários, quais sejam: Nome completo do titular da conta bancária; CPF do titular da conta bancária; Banco/Agência/Número da Conta Corrente; Número do localizador.\n\n'
              'IMPORTANTE: O REEMBOLSO DAS COMPRAS EFETUADAS VIA CARTÃO DE DÉBITO É FEITO VIA DEPÓSITO EM CONTA CORRENTE, A SER REALIZADO EM ATÉ 7 (SETE) DIAS ÚTEIS APÓS A SOLICITAÇÃO DO CANCELAMENTO.\n\n'
              'IMPORTANTE: NOS TERMOS DO ART.8º, §2º DA RESOLUÇÃO N.º 978 DA ANTT, FICA A TRANSPORTADORA AUTORIZADA A RETER ATÉ 5% (CINCO POR CENTO) DO VALOR PAGO PELA PASSAGEM RODOVIÁRIA, A TÍTULO DE MULTA COMPENSATÓRIA, NO CASO DE O PASSAGEIRO REALIZAR O CANCELAMENTO OU A TRANSFERÊNCIA, DENTRO DO PRAZO PREVISTO NO CAPUT DESTA CLÁUSULA.',
              style: GoogleFonts.inter(
                color: Configuracao().COR_SECUNDARIA,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 30),
            Text(
              '12° - DA PROPRIEDADE INTELECTUAL',
              style: GoogleFonts.inter(
                  color: Configuracao().COR_PRINCIPAL,
                  fontSize: 26,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 15),
            Text(
              '1. O “CLIENTE” acorda que o Website, assim como os logotipos, marcas, insígnias, fotos, imagens, descrições, textos, "layout", símbolos, sinais distintivos, manual(ais) e quaisquer outros materiais correlatos ao Website, constituem, conforme o caso, direitos autorais, segredos de negócio, e/ou direitos de propriedade da “VIACAO MONTES BELOS" ou seus licenciadores, conforme o caso, sendo tais direitos protegidos pela legislação nacional e internacional aplicável à propriedade intelectual, especialmente quanto aos termos e condições das Leis nºs 9.279/96, 9.609/98 e 9.610/98 e que não pleitearão ou reclamarão, a qualquer tempo, tais direitos de propriedade como se seus fossem.\n\n'
              '2. É expressamente proibido ao “CLIENTE” a reprodução, a distribuição, a modificação, a exibição, a criação de trabalhos derivados ou qualquer outra forma de utilização do conteúdo deste Website e dos materiais veiculados no ou pelo Website.\n\n'
              '“ANTT”: A Agência Nacional de Transportes Terrestres (ANTT) é uma autarquia federal brasileira responsável pela regulação das atividades de exploração da infraestrutura ferroviária e rodoviária federal e de prestação de serviços de transporte terrestre. A ANTT possui regulamento próprio e pela especificidade substitui obrigatoriedades de outros dispositivos.\n\n'
              'Em razão do disposto na Clausula acima, o “CLIENTE” acorda ter qualquer informação que tenha prestado ou transmitido, inclusive qualquer resposta a uma pergunta, a qualquer tempo, e sem necessidade de prévia notificação, deletada do Website, a critério exclusivo da “VIACAO MONTES BELOS", que ainda, poderá manter cópia em seus arquivos para as demais providências cabíveis, sem prejuízo de qualquer medida legal que se faça necessária. Tal faculdade visa proteger interesses dos demais “CLIENTES”, bem como da sociedade como um todo, visando mitigar riscos inerentes a tais práticas ilegais ou contrárias aos usos e costumes locais.\n\n'
              'Caso reste qualquer dúvida a respeito do conteúdo do presente instrumento, por favor, contate:\n\n'
              'Razão Social VIACAO MONTES BELOS LTDA\n'
              'Endereço: RUA 601, QUADRA 530 LOTE 07, SETOR SAO JOSE N 53 CEP 74440460\n'
              'Telefones: 062995415091\n\n'
              'Este contrato supera quaisquer acordos, verbais ou escritos, anteriormente mantidos entre as partes, especialmente com relação ao uso do Website pelo “CLIENTE”.\n\n'
              'O “CLIENTE”, ou, se for o caso, seu pai/mãe ou representante legal, reconhece expressamente ter lido, analisado e aceito integralmente as condições acima estabelecidas, comprometendo-se cumpri-las integralmente.\n\n'
              'VIACAO MONTES BELOS LTDA. Todos os direitos reservados.',
              style: GoogleFonts.inter(
                color: Configuracao().COR_SECUNDARIA,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
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
