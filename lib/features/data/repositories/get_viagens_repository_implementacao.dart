import 'package:dartz/dartz.dart';
import 'package:montesBelos/core/utils/constants/strings.dart';
import 'package:montesBelos/features/data/datasources/get_viagens_data_source.dart';
import 'package:montesBelos/features/data/models/get_viagens_request.dart';
import 'package:montesBelos/features/data/models/get_viagens_response.dart';
import 'package:montesBelos/features/domain/entities/viagem.dart';
import 'package:montesBelos/features/domain/repositories/get_viagens_repository.dart';

class GetViagensRepositoryImplementacao extends GetViagensRepository {
  GetViagensDataSource getViagensDataSource;
  List<Viagem> viagens = [];

  GetViagensRepositoryImplementacao(this.getViagensDataSource);

  @override
  Future<Either<Exception, List<Viagem>>> getViagens(
      GetViagensRequest getViagensRequest) async {
    try {
      final result = await getViagensDataSource.getViagens(getViagensRequest);
      if (result.viagensDto!.isNotEmpty) {
        inciarViagens();
        carregarViagens(result.viagensDto!);
        return Right(viagens);
      }
      return Left(Exception(get_viagens__texto_nenhuma_viagem_encontrada));
    } on Exception {
      return Left(Exception(falha_interna_no_servidor));
    }
  }

  inciarViagens() {
    viagens = [];
  }

  carregarViagens(List<ViagemDto> viagemDto) {
    for (var viagemDto in viagemDto) {
      var viagem = Viagem(
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
      viagens.add(viagem);
    }
  }
}
