import 'package:dartz/dartz.dart';
import 'package:montesBelos/core/utils/constants/strings.dart';
import 'package:montesBelos/features/data/datasources/get_agencias_data_source.dart';
import 'package:montesBelos/features/data/models/get_agencias_request.dart';
import 'package:montesBelos/features/data/models/get_agencias_response.dart';
import 'package:montesBelos/features/domain/entities/agencia.dart';
import 'package:montesBelos/features/domain/repositories/get_agencias_repository.dart';

class GetAgenciasRepositoryImplementacao extends GetAgenciasRepository {
  GetAgenciasDataSource getAgenciasDataSource;
  List<Agencia> agencias = [];
  Agencia agencia = Agencia();

  GetAgenciasRepositoryImplementacao(this.getAgenciasDataSource);

  @override
  Future<Either<Exception, List<Agencia>>> getAgencias(
      GetAgenciasRequest getAgenciasRequest) async {
    try {
      final result =
          await getAgenciasDataSource.getAgencias(getAgenciasRequest);
      if (result.agenciasDto!.isNotEmpty) {
        inciarAgencias();
        carregarAgencias(result.agenciasDto!);
        return Right(agencias);
      }
      return Left(Exception(get_agencias__texto_nenhuma_agencia_encontrada));
    } on Exception {
      return Left(Exception(falha_interna_no_servidor));
    }
  }

  inciarAgencias() {
    agencias = [];
  }

  inciarAgencia() {
    agencia = Agencia();
  }

  carregarAgencias(List<AgenciaDto> agenciasDto) {
    for (var agenciaDto in agenciasDto) {
      var agencia = Agencia(
          id: agenciaDto.id,
          name: agenciaDto.name,
          uf: agenciaDto.uf,
          urlAmigavel: agenciaDto.urlAmigavel);
      agencias.add(agencia);
    }
  }

  @override
  Future<Either<Exception, Agencia>> getAgenciaPorNome(
      String nome, int busCompany) async {
    try {
      final result =
          await getAgenciasDataSource.getAgenciasPorNome(nome, busCompany);
      if (result.agenciasDto!.isNotEmpty && result.agenciasDto != null) {
        carregarAgencia(result.agenciasDto!.first);
        return Right(agencia);
      }
      return Left(Exception(get_agencias__texto_nenhuma_agencia_encontrada));
    } on Exception {
      return Left(Exception(falha_interna_no_servidor));
    }
  }

  carregarAgencia(AgenciaDto agenciaDto) {
    this.agencia = Agencia(
        id: agenciaDto.id,
        name: agenciaDto.name,
        uf: agenciaDto.uf,
        urlAmigavel: agenciaDto.urlAmigavel);
  }
}
