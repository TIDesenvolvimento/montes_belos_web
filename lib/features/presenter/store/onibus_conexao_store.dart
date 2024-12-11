import 'package:flutter_triple/flutter_triple.dart';
import 'package:montesBelos/features/data/models/onibus_request.dart';
import 'package:montesBelos/features/domain/entities/agencia.dart';
import 'package:montesBelos/features/domain/entities/onibus.dart';
import 'package:montesBelos/features/domain/usecases/get_agencias_use_case.dart';
import 'package:montesBelos/features/domain/usecases/onibus_conexao_use_case.dart';
import 'package:montesBelos/features/presenter/model/onibus_conexao_status.dart';

// ignore: must_be_immutable
class OnibusConexaoStore extends NotifierStore<Exception, OnibusConexaoStatus> {
  final OnibusConexaoUseCase onibusConexaoUseCase;
  final GetAgenciasUseCase getAgenciasUseCase;

  OnibusConexaoStatus onibusConexaoStatus = OnibusConexaoStatus(
      frota: [],
      origem: Agencia(),
      destino: Agencia(),
      onibusCarregado: false,
      quantidadeDeViagem: 0);

  OnibusConexaoStore(this.onibusConexaoUseCase, this.getAgenciasUseCase)
      : super(OnibusConexaoStatus(
            frota: [],
            origem: Agencia(),
            destino: Agencia(),
            onibusCarregado: false,
            quantidadeDeViagem: 0));

  getLayoutDoOnibusConexao(OnibusRequest onibusRequest) async {
    setLoading(true);
    final result = await onibusConexaoUseCase(onibusRequest);
    result.fold((erro) {
      setError(erro);
      setLoading(false);
    }, (sucesso) {
      iniciarFrota();
      carregarFrota(sucesso);
      update(onibusConexaoStatus);
    });
  }

  getAgenciaDeOrigemPorUrlAmigavel(String urlAmigavelOrigem,
      String urlAmigavelDestino, int busCompany) async {
    final result = await getAgenciasUseCase.getAgenciaPorNome(
        urlAmigavelOrigem, busCompany);
    result.fold((erro) {
      setError(erro);
      setLoading(false);
    }, (sucesso) {
      iniciarFrota();
      carregarOrigem(sucesso);
      getAgenciaDeDestinoPorUrlAmigavel(urlAmigavelDestino, busCompany);
    });
  }

  getAgenciaDeDestinoPorUrlAmigavel(
      String urlAmigavelDestino, int busCompany) async {
    final result = await getAgenciasUseCase.getAgenciaPorNome(
        urlAmigavelDestino, busCompany);
    result.fold((erro) {
      setError(erro);
      setLoading(false);
    }, (sucesso) {
      carregarDestino(sucesso);
      update(OnibusConexaoStatus(
          frota: [],
          origem: onibusConexaoStatus.origem,
          destino: sucesso,
          onibusCarregado: true,
          quantidadeDeViagem: 0));
    });
  }

  iniciarFrota() {
    onibusConexaoStatus.frota = [];
  }

  carregarFrota(List<Onibus> frota) {
    onibusConexaoStatus.frota = frota;
  }

  carregarOrigem(Agencia agencia) {
    onibusConexaoStatus.origem = agencia;
  }

  carregarDestino(Agencia agencia) {
    onibusConexaoStatus.destino = agencia;
  }
}
