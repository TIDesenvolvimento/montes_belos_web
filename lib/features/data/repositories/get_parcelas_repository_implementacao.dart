import 'package:dartz/dartz.dart';
import 'package:montesBelos/core/utils/constants/strings.dart';
import 'package:montesBelos/features/data/datasources/get_parcelas_data_source.dart';
import 'package:montesBelos/features/data/models/parcela_response.dart';
import 'package:montesBelos/features/domain/entities/parcela_status.dart';
import 'package:montesBelos/features/domain/repositories/get_parcelas_repository.dart';

class GetParcelasRepositoryImplementacao extends GetParcelasRepository {
  GetParcelasDataSource getParcelasDataSource;
  ParcelaStatus parcelaStatus = ParcelaStatus();

  GetParcelasRepositoryImplementacao(this.getParcelasDataSource);

  @override
  Future<Either<Exception, ParcelaStatus>> getParcelas(bool ativo) async {
    try {
      final result = await getParcelasDataSource.getParcelas();
      if (result.parcelasDto!.isNotEmpty) {
        iniciarParcelaStatus();
        carregarParcelaStatus(result);
        return Right(parcelaStatus);
      }
      return Left(Exception(get_agencias__texto_nenhuma_agencia_encontrada));
    } on Exception {
      return Left(Exception(falha_interna_no_servidor));
    }
  }

  iniciarParcelaStatus() {
    parcelaStatus = ParcelaStatus();
    parcelaStatus.parcelas = [];
  }

  carregarParcelaStatus(ParcelaResponse parcelaResponse) {
    for (var parcelaResponse in parcelaResponse.parcelasDto!) {
      var parcela = Parcela(
          id: parcelaResponse.id,
          numeroParcelas: parcelaResponse.numeroParcelas,
          taxa: parcelaResponse.taxa);
      parcelaStatus.parcelas!.add(parcela);
    }
    parcelaStatus.totalDeParcelas = parcelaResponse.totalDeParcelas;
  }
}
