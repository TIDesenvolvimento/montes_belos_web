import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart' as http;
import 'package:montesBelos/features/data/datasources/atualizar_cliente_data_source_implementacao.dart';
import 'package:montesBelos/features/data/datasources/cadastrar_usuario_data_source_implementacao.dart';
import 'package:montesBelos/features/data/datasources/cancelar_voucher_data_source_implementacao.dart';
import 'package:montesBelos/features/data/datasources/fale_conosco_data_source_implementacao.dart';
import 'package:montesBelos/features/data/datasources/get_agencias_data_source_implementacao.dart';
import 'package:montesBelos/features/data/datasources/get_compras_data_source_implementacao.dart';
import 'package:montesBelos/features/data/datasources/get_parcelas_data_source_implementacao.dart';
import 'package:montesBelos/features/data/datasources/get_telefone_das_agencias_data_source_implementacao.dart';
import 'package:montesBelos/features/data/datasources/get_viagens_data_source_implementacao.dart';
import 'package:montesBelos/features/data/datasources/login_data_source_implementacao.dart';
import 'package:montesBelos/features/data/datasources/onibus_conexao_data_source_implementacao.dart';
import 'package:montesBelos/features/data/datasources/onibus_data_source_implementacao.dart';
import 'package:montesBelos/features/data/datasources/pagamento_data_source_implementacao.dart';
import 'package:montesBelos/features/data/datasources/pagamento_pix_data_source_implementacao.dart';
import 'package:montesBelos/features/data/datasources/redefinir_senha_data_source_implementacao.dart';
import 'package:montesBelos/features/data/repositories/atualizar_cliente_repository_implementacao.dart';
import 'package:montesBelos/features/data/repositories/cadastrar_usuario_repository_implementacao.dart';
import 'package:montesBelos/features/data/repositories/cancelar_voucher_repository_implementacao.dart';
import 'package:montesBelos/features/data/repositories/fale_conosco_repository_implementacao.dart';
import 'package:montesBelos/features/data/repositories/get_agencias_repository_implementacao.dart';
import 'package:montesBelos/features/data/repositories/get_compras_repository_implementacao.dart';
import 'package:montesBelos/features/data/repositories/get_parcelas_repository_implementacao.dart';
import 'package:montesBelos/features/data/repositories/get_telefone_das_agencias_repository_implementacao.dart';
import 'package:montesBelos/features/data/repositories/get_viagens_repository_implementacao.dart';
import 'package:montesBelos/features/data/repositories/login_repository_implementacao.dart';
import 'package:montesBelos/features/data/repositories/onibus_conexao_repository_implementacao.dart';
import 'package:montesBelos/features/data/repositories/onibus_repository_implementacao.dart';
import 'package:montesBelos/features/data/repositories/pagamento_pix_repository_implementacao.dart';
import 'package:montesBelos/features/data/repositories/pagamento_repository_implementacao.dart';
import 'package:montesBelos/features/data/repositories/redefinir_senha_repository_implementacao.dart';
import 'package:montesBelos/features/domain/usecases/atualizar_cliente_use_case.dart';
import 'package:montesBelos/features/domain/usecases/cadastrar_usuario_use_case.dart';
import 'package:montesBelos/features/domain/usecases/cancelar_voucher_use_case.dart';
import 'package:montesBelos/features/domain/usecases/fale_conosco_use_case.dart';
import 'package:montesBelos/features/domain/usecases/get_agencias_use_case.dart';
import 'package:montesBelos/features/domain/usecases/get_compras_use_case.dart';
import 'package:montesBelos/features/domain/usecases/get_parcelas_use_case.dart';
import 'package:montesBelos/features/domain/usecases/get_telefone_das_agencias_use_case.dart';
import 'package:montesBelos/features/domain/usecases/get_viagens_use_case.dart';
import 'package:montesBelos/features/domain/usecases/login_use_case.dart';
import 'package:montesBelos/features/domain/usecases/onibus_conexao_use_case.dart';
import 'package:montesBelos/features/domain/usecases/onibus_use_case.dart';
import 'package:montesBelos/features/domain/usecases/pagamento_pix_use_case.dart';
import 'package:montesBelos/features/domain/usecases/pagamento_use_case.dart';
import 'package:montesBelos/features/domain/usecases/redefinir_senha_use_case.dart';
import 'package:montesBelos/features/presenter/pages/busca_page.dart';
import 'package:montesBelos/features/presenter/pages/busca_page_mobile.dart';
import 'package:montesBelos/features/presenter/pages/como_comprar_page.dart';
import 'package:montesBelos/features/presenter/pages/como_comprar_page_mobile.dart';
import 'package:montesBelos/features/presenter/pages/destino_page_mobile.dart';
import 'package:montesBelos/features/presenter/pages/fale_conosco_page.dart';
import 'package:montesBelos/features/presenter/pages/fale_conosco_page_mobile.dart';
import 'package:montesBelos/features/presenter/pages/ida_page.dart';
import 'package:montesBelos/features/presenter/pages/ida_page_mobile.dart';
import 'package:montesBelos/features/presenter/pages/login_page%20mobile.dart';
import 'package:montesBelos/features/presenter/pages/login_page.dart';
import 'package:montesBelos/features/presenter/pages/meus_dados_page.dart';
import 'package:montesBelos/features/presenter/pages/meus_dados_page_mobile.dart';
import 'package:montesBelos/features/presenter/pages/minhas_compras_page.dart';
import 'package:montesBelos/features/presenter/pages/minhas_compras_page_mobile.dart';
import 'package:montesBelos/features/presenter/pages/nossa_frota_page.dart';
import 'package:montesBelos/features/presenter/pages/nossa_frota_page_mobile.dart';
import 'package:montesBelos/features/presenter/pages/novo_usuario_page.dart';
import 'package:montesBelos/features/presenter/pages/novo_usuario_page_mobile.dart';
import 'package:montesBelos/features/presenter/pages/origem_page_mobile.dart';
import 'package:montesBelos/features/presenter/pages/politica_de_privacidade_page.dart';
import 'package:montesBelos/features/presenter/pages/politica_de_privacidade_page_mobile.dart';
import 'package:montesBelos/features/presenter/pages/redirecionamento_page.dart';
import 'package:montesBelos/features/presenter/pages/resumo_de_compra_page.dart';
import 'package:montesBelos/features/presenter/pages/resumo_de_compra_page_mobile.dart';
import 'package:montesBelos/features/presenter/pages/servicos_page.dart';
import 'package:montesBelos/features/presenter/pages/servicos_page_mobile.dart';
import 'package:montesBelos/features/presenter/pages/telefone_das_agencias_page.dart';
import 'package:montesBelos/features/presenter/pages/telefone_das_agencias_page_mobile.dart';
import 'package:montesBelos/features/presenter/pages/termos_de_uso_page.dart';
import 'package:montesBelos/features/presenter/pages/termos_de_uso_page_mobile.dart';
import 'package:montesBelos/features/presenter/pages/volta_page.dart';
import 'package:montesBelos/features/presenter/pages/volta_page_mobile.dart';
import 'package:montesBelos/features/presenter/store/atualizar_cliente_store.dart';
import 'package:montesBelos/features/presenter/store/busca_store.dart';
import 'package:montesBelos/features/presenter/store/cancelar_voucher_store.dart';
import 'package:montesBelos/features/presenter/store/fale_conosco_store.dart';
import 'package:montesBelos/features/presenter/store/get_compras_store.dart';
import 'package:montesBelos/features/presenter/store/get_destino_store.dart';
import 'package:montesBelos/features/presenter/store/get_origem_store.dart';
import 'package:montesBelos/features/presenter/store/get_parcelas_store.dart';
import 'package:montesBelos/features/presenter/store/get_telefone_das_agencias_store.dart';
import 'package:montesBelos/features/presenter/store/get_viagem_store.dart';
import 'package:montesBelos/features/presenter/store/login_store.dart';
import 'package:montesBelos/features/presenter/store/novo_usuario_store.dart';
import 'package:montesBelos/features/presenter/store/onibus_conexao_store.dart';
import 'package:montesBelos/features/presenter/store/onibus_store.dart';
import 'package:montesBelos/features/presenter/store/pagamento_pix_store.dart';
import 'package:montesBelos/features/presenter/store/pagamento_store.dart';
import 'package:montesBelos/features/presenter/store/redefinir_senha_store.dart';
import 'package:montesBelos/features/presenter/utils/responsive_layout.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.factory((i) => OrigemStore(i())),
    Bind.factory((i) => DestinoStore(i())),
    Bind.factory((i) => BuscaStore()),
    Bind.factory((i) => OnibusConexaoStore(i(), i())),
    Bind.factory((i) => ViagemStore(i())),
    Bind.factory((i) => OnibusStore(i())),
    Bind.factory((i) => LoginStore(i())),
    Bind.factory((i) => RedefinirSenhaStore(i())),
    Bind.factory((i) => NovoUsuarioStore(i())),
    Bind.factory((i) => FaleConoscoStore(i())),
    Bind.factory((i) => AtualizarClienteStore(i())),
    Bind.factory((i) => GetTelefoneDasAgenciasStore(i())),
    Bind.factory((i) => ParcelaStore(i())),
    Bind.factory((i) => ComprasStore(i())),
    Bind.factory((i) => PagamentoViaPixStore(i())),
    Bind.factory((i) => CancelarVoucherStore(i())),
    Bind.factory((i) => PagamentoStore(i())),
    Bind.lazySingleton((i) => GetAgenciasUseCase(i())),
    Bind.lazySingleton((i) => GetAgenciasRepositoryImplementacao(i())),
    Bind.lazySingleton((i) => GetAgenciasDataSourceImplementacao(client: i())),
    Bind.lazySingleton((i) => OnibusUseCase(i())),
    Bind.lazySingleton((i) => OnibusRepositoryImplementacao(i())),
    Bind.lazySingleton((i) => OnibusDataSourceImplementacao(client: i())),
    Bind.lazySingleton((i) => GetViagensUseCase(i())),
    Bind.lazySingleton((i) => GetViagensRepositoryImplementacao(i())),
    Bind.lazySingleton((i) => GetViagensDataSourceImplementacao(client: i())),
    Bind.lazySingleton((i) => LoginUseCase(i())),
    Bind.lazySingleton((i) => LoginRepositoryImplementacao(i())),
    Bind.lazySingleton((i) => LoginDataSourceImplementacao(client: i())),
    Bind.lazySingleton((i) => CadastrarUsuarioUseCase(i())),
    Bind.lazySingleton((i) => CadastrarUsuarioRepositoryImplementacao(i())),
    Bind.lazySingleton(
        (i) => CadastrarUsuarioDataSourceImplementacao(client: i())),
    Bind.lazySingleton((i) => RedefinirSenhaUseCase(i())),
    Bind.lazySingleton((i) => RedefinirSenhaRepositoryImplementacao(i())),
    Bind.lazySingleton(
        (i) => RedefinirSenhaDataSourceImplementacao(client: i())),
    Bind.lazySingleton((i) => AtualizarClienteUseCase(i())),
    Bind.lazySingleton((i) => AtualizarClienteRepositoryImplementacao(i())),
    Bind.lazySingleton(
        (i) => AtualizarclienteDataSourceImplementacao(client: i())),
    Bind.lazySingleton((i) => GetComprasUseCase(i())),
    Bind.lazySingleton((i) => GetComprasRepositoryImplementacao(i())),
    Bind.lazySingleton((i) => GetComprasDataSourceImplementacao(client: i())),
    Bind.lazySingleton((i) => OnibusConexaoUseCase(i())),
    Bind.lazySingleton((i) => OnibusConexaoRepositoryImplementacao(i())),
    Bind.lazySingleton(
        (i) => OnibusConexaoDataSourceImplementacao(client: i())),
    Bind.lazySingleton((i) => FaleConoscoUseCase(i())),
    Bind.lazySingleton((i) => FaleConoscoRepositoryImplementacao(i())),
    Bind.lazySingleton((i) => FaleConoscoDataSourceImplementacao(client: i())),
    Bind.lazySingleton((i) => GetTelefoneDasAgenciasUseCase(i())),
    Bind.lazySingleton(
        (i) => GetTelefoneDasAgenciasRepositoryImplementacao(i())),
    Bind.lazySingleton(
        (i) => GetTelefoneDasAgenciasDataSourceImplementacao(client: i())),
    Bind.lazySingleton((i) => GetParcelasUseCase(i())),
    Bind.lazySingleton((i) => GetParcelasRepositoryImplementacao(i())),
    Bind.lazySingleton((i) => GetParcelasDataSourceImplementacao(client: i())),
    Bind.lazySingleton((i) => PagamentoViaPixUseCase(i())),
    Bind.lazySingleton((i) => PagamentoViaPixRepositoryImplementacao(i())),
    Bind.lazySingleton(
        (i) => PagamentoViaPixDataSourceImplementacao(client: i())),
    Bind.lazySingleton((i) => PagamentoUseCase(i())),
    Bind.lazySingleton((i) => PagamentoRepositoryImplementacao(i())),
    Bind.lazySingleton((i) => PagamentoDataSourceImplementacao(client: i())),
    Bind.lazySingleton((i) => CancelarVoucherUseCase(i())),
    Bind.lazySingleton((i) => CancelarVoucherRepositoryImplementacao(i())),
    Bind.lazySingleton(
        (i) => CancelarVoucherDataSourceImplementacao(client: i())),
    Bind.lazySingleton((i) => http.Client()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/',
        child: (_, __) => ResponsiveLayout(
              mobileBody: BuscaPageMobile(),
              tabletBody: BuscaPageMobile(),
              desktopBody: BuscaPage(),
            )),
    ChildRoute('/viagem_ida',
        child: (_, __) => ResponsiveLayout(
              mobileBody: IdaPageMobile.fromArgs(__.data),
              tabletBody: IdaPageMobile.fromArgs(__.data),
              desktopBody: IdaPage.fromArgs(__.data),
            )),
    ChildRoute('/viagem_volta',
        child: (_, __) => ResponsiveLayout(
              mobileBody: VoltaPageMobile.fromArgs(__.data),
              tabletBody: VoltaPageMobile.fromArgs(__.data),
              desktopBody: VoltaPage.fromArgs(__.data),
            )),
    ChildRoute('/login',
        child: (_, __) => ResponsiveLayout(
              mobileBody: LoginPageMobile(),
              tabletBody: LoginPageMobile(),
              desktopBody: LoginPage(),
            )),
    ChildRoute('/novo_usuario',
        child: (_, __) => ResponsiveLayout(
              mobileBody: NovoUsuarioPageMobile(),
              tabletBody: NovoUsuarioPageMobile(),
              desktopBody: NovoUsuarioPage(),
            )),
    ChildRoute('/servicos',
        child: (_, __) => ResponsiveLayout(
              mobileBody: ServicosPageMobile(),
              tabletBody: ServicosPageMobile(),
              desktopBody: ServicosPage(),
            )),
    ChildRoute('/frota',
        child: (_, __) => ResponsiveLayout(
              mobileBody: NossaFrotaPageMobile(),
              tabletBody: NossaFrotaPageMobile(),
              desktopBody: NossaFrotaPage(),
            )),
    ChildRoute('/fale_conosco',
        child: (_, __) => ResponsiveLayout(
              mobileBody: FaleConoscoPageMobile(),
              tabletBody: FaleConoscoPageMobile(),
              desktopBody: FaleConoscoPage(),
            )),
    ChildRoute('/dados',
        child: (_, __) => ResponsiveLayout(
              mobileBody: MeusDadosPageMobile(),
              tabletBody: MeusDadosPageMobile(),
              desktopBody: MeusDadosPage(),
            )),
    ChildRoute('/como_comprar',
        child: (_, __) => ResponsiveLayout(
              mobileBody: ComoComprarPageMobile(),
              tabletBody: ComoComprarPageMobile(),
              desktopBody: ComoComprarPage(),
            )),
    ChildRoute('/compras',
        child: (_, __) => ResponsiveLayout(
              mobileBody: MinhasComprasPageMobile(),
              tabletBody: MinhasComprasPageMobile(),
              desktopBody: MinhasComprasPage(),
            )),
    ChildRoute('/pagamento',
        child: (_, __) => ResponsiveLayout(
              mobileBody: ResumoDeCompraPageMobile(),
              tabletBody: ResumoDeCompraPageMobile(),
              desktopBody: ResumoDeCompraPage(),
            )),
    ChildRoute('/agenciass',
        child: (_, __) => ResponsiveLayout(
              mobileBody: TelefoneDasAgenciasMobile(),
              tabletBody: TelefoneDasAgenciasMobile(),
              desktopBody: TelefoneDasAgenciasPage(),
            )),
    ChildRoute('/termos_de_uso',
        child: (_, __) => ResponsiveLayout(
              mobileBody: TermosDeUsoPageMobile(),
              tabletBody: TermosDeUsoPageMobile(),
              desktopBody: TermosDeUsoPage(),
            )),
    ChildRoute('/politica',
        child: (_, __) => ResponsiveLayout(
              mobileBody: PoliticaDePrivacidadePageMobile(),
              tabletBody: PoliticaDePrivacidadePageMobile(),
              desktopBody: PoliticaDePrivacidadePage(),
            )),
    ChildRoute('/origem',
        child: (_, __) => ResponsiveLayout(
              mobileBody: OrigemPage(),
              tabletBody: OrigemPage(),
              desktopBody: OrigemPage(),
            )),
    ChildRoute('/destino',
        child: (_, __) => ResponsiveLayout(
              mobileBody: DestinoPage(),
              tabletBody: DestinoPage(),
              desktopBody: DestinoPage(),
            )),
    ChildRoute('/redirecionamento',
        child: (_, __) => ResponsiveLayout(
              mobileBody: RedirectPage(),
              tabletBody: RedirectPage(),
              desktopBody: RedirectPage(),
            )),
  ];
}
