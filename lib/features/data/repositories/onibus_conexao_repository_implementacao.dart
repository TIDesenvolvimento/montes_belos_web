import 'package:dartz/dartz.dart';
import 'package:montesBelos/core/utils/constants/strings.dart';
import 'package:montesBelos/features/data/datasources/onibus_conexao_data_source.dart';
import 'package:montesBelos/features/data/models/get_viagens_response.dart';
import 'package:montesBelos/features/data/models/onibus_request.dart';
import 'package:montesBelos/features/data/models/onibus_response.dart';
import 'package:montesBelos/features/data/models/purchase_request.dart';
import 'package:montesBelos/features/domain/entities/onibus.dart';
import 'package:montesBelos/features/domain/repositories/onibus_conexao_repository.dart';

class OnibusConexaoRepositoryImplementacao extends OnibusConexaoRepository {
  OnibusConexaoDataSource onibusConexaoDataSource;
  List<Onibus> frota = [];

  OnibusConexaoRepositoryImplementacao(this.onibusConexaoDataSource);

  @override
  Future<Either<Exception, List<Onibus>>> getLayoutDoOnibusConexao(
      OnibusRequest onibusRequest) async {
    try {
      final result =
          await onibusConexaoDataSource.getLayoutDoOnibusConexao(onibusRequest);
      if (result.frota != null || result.frota!.isNotEmpty) {
        iniciarFrota();
        carregarFrotaDeOnibus(result.frota);
        return Right(frota);
      }
      return Left(Exception(get_agencias__texto_nenhuma_agencia_encontrada));
    } on Exception {
      return Left(Exception(falha_interna_no_servidor));
    }
  }

  iniciarFrota() {
    frota = [];
  }

  carregarFrotaDeOnibus(List<OnibusResponse>? frota) {
    for (var onibusResponse in frota!) {
      var onibus = getOnibus(onibusResponse);
      this.frota.add(onibus);
    }
  }

  Onibus getOnibus(OnibusResponse onibusResponse) {
    return Onibus(
        maxSelection: onibusResponse.maxSelection,
        viagem: getViagem(onibusResponse.viagemDto!),
        busLayout: getBusLayout(onibusResponse.busLayoutDto!),
        priceInfo: getPriceInfo(onibusResponse.priceInfoDto!));
  }

  ViagemOriginal getViagem(ViagemDto viagemDto) {
    return ViagemOriginal(
      arrival: viagemDto.arrival,
      boardingFee: viagemDto.boardingFee,
      busCompany: viagemDto.busCompany,
      busCompanyName: viagemDto.busCompanyName,
      busType: viagemDto.busType,
      date: viagemDto.date,
      departure: viagemDto.departure,
      destination: viagemDto.destination,
      destinationName: viagemDto.destinationName,
      destinationUf: viagemDto.destinationUf,
      discount: viagemDto.discount,
      freeSeats: viagemDto.freeSeats,
      horarioSaidaConexao: viagemDto.horarioSaidaConexao,
      icmsValue: viagemDto.icmsValue,
      id: viagemDto.id,
      idConexao: viagemDto.idConexao,
      isConexao: viagemDto.isConexao,
      message: viagemDto.message,
      origin: viagemDto.origin,
      originName: viagemDto.originName,
      originUf: viagemDto.originUf,
      otherTaxes: viagemDto.otherTaxes,
      price: viagemDto.price,
      priceRate: viagemDto.priceRate,
      sequenciaConexao: viagemDto.sequenciaConexao,
      service: viagemDto.service,
      serviceTax: viagemDto.serviceTax,
      time: viagemDto.time,
      toll: viagemDto.toll,
      urlLogo: viagemDto.urlLogo,
    );
  }

  BusLayout getBusLayout(BusLayoutDto busLayoutDto) {
    return BusLayout(decks: getDecks(busLayoutDto.decksDto!));
  }

  List<Decks> getDecks(List<DecksDto> decksDto) {
    List<Decks> decks = [];
    for (var deckDto in decksDto) {
      var deck = Decks(
          id: deckDto.id,
          number: deckDto.number,
          seats: getSeats(deckDto.seatsDto!));
      decks.add(deck);
    }
    return decks;
  }

  List<Seat> getSeats(List<SeatsDto> seatsDto) {
    List<Seat> seats = [];
    for (var seatDto in seatsDto) {
      if (seatDto.number != 'mot') {
        var seat = Seat(
            id: seatDto.id,
            label: seatDto.label,
            number: seatDto.number,
            type: seatDto.type,
            x: seatDto.x,
            y: seatDto.y,
            index: transformarEmIndex(seatDto.x! + seatDto.y!));
        seats.add(seat);
      }
    }
    return seats;
  }

  int? transformarEmIndex(String valor) {
    Map<String, int> map1 = {
      '11': 4,
      '12': 3,
      '13': 0,
      '14': 1,
      '21': 9,
      '22': 8,
      '23': 5,
      '24': 6,
      '31': 14,
      '32': 13,
      '33': 10,
      '34': 11,
      '41': 19,
      '42': 18,
      '43': 15,
      '44': 16,
      '51': 24,
      '52': 23,
      '53': 20,
      '54': 21,
      '61': 29,
      '62': 28,
      '63': 25,
      '64': 26,
      '71': 34,
      '72': 33,
      '73': 30,
      '74': 31,
      '81': 39,
      '82': 38,
      '83': 35,
      '84': 36,
      '91': 44,
      '92': 43,
      '93': 40,
      '94': 41,
      '101': 49,
      '102': 48,
      '103': 45,
      '104': 46,
      '111': 54,
      '112': 53,
      '113': 50,
      '114': 51,
      '121': 59,
      '122': 58,
      '123': 55,
      '124': 56,
      '131': 64,
      '132': 63,
      '133': 60,
      '134': 61
    };
    return map1[valor];
  }

  PriceInfo getPriceInfo(PriceInfoDto priceInfoDto) {
    return PriceInfo(
        basePrice: priceInfoDto.basePrice,
        boardingPrice: priceInfoDto.boardingPrice,
        serviceCharge: priceInfoDto.serviceCharge,
        tollCharge: priceInfoDto.tollCharge,
        total: priceInfoDto.total);
  }
}
