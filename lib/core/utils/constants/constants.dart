class Constants {
  static const BASE_URL = "api.passagensbr.com.br";
  // static const BASE_URL = "192.168.1.33:8081";

  static const VERSAO_DO_APP = "2.0";
  static const FONT_DO_APP = 'Poppins';

  static const STATUS_CODE_200 = 200;
  static const STATUS_CODE_500 = 500;
  static const STATUS_CODE_404 = 404;
  static const STATUS_CODE_403 = 403;
  static const STATUS_SUCESS = 'success';

  static const ZERO = 0;
  static const UM = 1;
  static const NULL = null;
  static const VAZIO = '';
  static const STATUS_PENDING = 'pending';

  static const CHAVE_ADYEN_PASSAGENS_BR =
      '10001|AC2E832AD0DBDBD320998D7DE3950ECF64A4F3D0CD38EE18E9B9DA1A318990470F04CC1F11BDCF430A9D3D842063F5D0F634836E0801EC1F9F199FBDB1405E3435117F5F24C06FA3A802880E551B4A7FC11E4924CF8335A8AD23B292F336A5BEBA48CE1A89AE72509E0F3E19C7FC1AE172AC1031AFD5EE7F3BF394CD20D742870D446B2A184FA8A675B1CF97931903F9D58A2EA213E5254E45817B694EE63ED8974D8179E004E1D220C7255B4EAC8962A5C3C895090B75E235C3615B9FFD25DCAC167ACF06C9B7FCD1BC8DE0D558C4D4458961AD44311820B5E7436FA79960EC2C3E7DA6FB986EBA15634EB9BDAD65006676C3C011F5E8384FE9E88A40F27DBF';
  static const CHAVE_ADYEN_REAL_MAIA =
      '10001|D81422759746A4F2FD1B5A0AA482819696F07587B0301D8B83CBE85006ECF2839DCB4CC2877F7C72D66CBB891F0B41C5A1ACDA16950AA4406E532782769406B9033A8762E52DF1EEBDF2BB03AA34FDF7CA51CA131FBCC0496565B2F03A6E27A717860CFA9E59E8E6B3B5AD00801D0936A1BC1BFA06B2499322E623B7D2250242FE2D5CB1E49EB81DCDAE32E815468D2A5981D69DE72E47D0B2455148511E19B75B69E5E9C739D658F828474500F19F7D402063E2B6D8AF8318EA2A3E741C2B27AF51D3D86C540B647E8BA000A048F6E6E9B575D8CA64D15B10FC5AFBF6A5978CAB0AB8AF4078309A56ACD0BDB9F69ED7798FE3316C7A37276EC3284660E5EECF';

  static const HOME_PAGE__BOTTOM_NAVIGATION_BAR_BUSCA = "Busca";
  static const HOME_PAGE__BOTTOM_NAVIGATION_BAR_PASSAGEIROS = "Passageiros";
  static const HOME_PAGE__BOTTOM_NAVIGATION_BAR_PEDIDOS = "Pedidos";
  static const HOME_PAGE__BOTTOM_NAVIGATION_BAR_CONTA = "Conta";

  static const DIA_ANTERIOR_PARA_MOSTRAR_VIAGEM = 3;

  static const POLTRONA_SELECIONADA = "6";
  static const POLTRONA_SEM_SELECAO = "0";
  static const POLTRONA_DE_REAPROVEITAMENTO = "2";
  static const POLTRONA_LP = "3";
  static const POLTRONA_VENDIDA = "1";
  static const POLTRONA_RESERVADA = "5";
  static const POLTRONA_BLOQUEADA = "8";
  static const POLTRONA_ESCOLHIDA = "7";
  static const POLTRONA_REMOVIDA = "51";
  static const TIPO_DE_POLTRONA_SELECIONADA = "Selecionada";
  static const TIPO_DE_POLTRONA_DISPONIVEL = "Disponível";
  static const TIPO_DE_POLTRONA_OCUPADA = "Ocupada";

  static const MAXIMO_DE_POLTRONAS_SELECIONADAS = 4;
  static const MAXIMO_DE_POLTRONAS_SELECIONADAS_CONEXAO = 1;

  static const PREPOSICAO_DO = "do";
  static const PREPOSICAO_DOS = "dos";
  static const PREPOSICAO_DE = "de";
  static const PREPOSICAO_DA = "da";
  static const PREPOSICAO_DAS = "das";

  static const UF_RO = "RO";
  static const UF_AC = "AC";
  static const UF_AM = "AM";
  static const UF_RR = "PR";
  static const UF_PA = "PA";
  static const UF_AP = "AP";
  static const UF_TO = "TO";
  static const UF_MA = "MA";
  static const UF_PI = "PI";
  static const UF_CE = "CE";
  static const UF_RN = "RN";
  static const UF_PB = "PB";
  static const UF_PE = "PE";
  static const UF_AL = "AL";
  static const UF_SE = "SE";
  static const UF_BA = "BA";
  static const UF_MG = "MG";
  static const UF_ES = "ES";
  static const UF_RJ = "RJ";
  static const UF_SP = "SP";
  static const UF_PR = "PR";
  static const UF_SC = "SC";
  static const UF_RS = "RS";
  static const UF_MS = "MS";
  static const UF_MT = "MT";
  static const UF_GO = "GO";
  static const UF_DF = "DF";

  static const List<String> ufs = <String>[
    Constants.UF_AC,
    Constants.UF_AL,
    Constants.UF_AM,
    Constants.UF_AP,
    Constants.UF_BA,
    Constants.UF_CE,
    Constants.UF_DF,
    Constants.UF_ES,
    Constants.UF_GO,
    Constants.UF_MA,
    Constants.UF_MG,
    Constants.UF_MS,
    Constants.UF_MT,
    Constants.UF_PA,
    Constants.UF_PB,
    Constants.UF_PE,
    Constants.UF_PI,
    Constants.UF_PR,
    Constants.UF_RJ,
    Constants.UF_RN,
    Constants.UF_RO,
    Constants.UF_RR,
    Constants.UF_RS,
    Constants.UF_SC,
    Constants.UF_SE,
    Constants.UF_SP,
    Constants.UF_TO
  ];

  static const PAGAMENTO_VIA_CARTAO = 'Cartão';
  static const PAGAMENTO_VIA_PIX = 'Pix';

  static const PAGAMENTO_VIA_CARD = 'CreditCard';
}
