import 'package:dartz/dartz.dart';
import 'package:montesBelos/core/utils/constants/strings.dart';
import 'package:montesBelos/features/data/datasources/get_compras_data_source.dart';
import 'package:montesBelos/features/data/models/get_compras_response.dart';
import 'package:montesBelos/features/domain/entities/get_compras.dart';
import 'package:montesBelos/features/domain/repositories/get_compras_repository.dart';

class GetComprasRepositoryImplementacao extends GetComprasRepository {
  GetComprasDataSource getComprasDataSource;

  GetComprasRepositoryImplementacao(this.getComprasDataSource);

  @override
  Future<Either<Exception, GetCompras>> getCompras(
      String tokenDoCliente) async {
    try {
      final result = await getComprasDataSource.getCompras(tokenDoCliente);
      if (result.comprasDto != null) {
        return Right(getComprasStatus(result));
      }
      return Left(Exception(get_informacao_do_servidor__text_erro));
    } on Exception {
      return Left(Exception(falha_interna_no_servidor));
    }
  }

  GetCompras getComprasStatus(GetComprasReponse getComprasReponse) {
    return GetCompras(
        total: getComprasReponse.total,
        compras: carregarCompras(getComprasReponse.comprasDto!));
  }

  List<Compra> carregarCompras(List<ComprasDto> comprasDto) {
    List<Compra> compras = [];
    for (var comprasDto in comprasDto) {
      var compra = Compra(
        id: comprasDto.id,
        dataCriacao: comprasDto.dataCriacao,
        status: comprasDto.status,
        valor: comprasDto.valor,
        detalhesDaCompra:
            carregarDetalhesDasCompras(comprasDto.detalhesDaCompraDto!),
      );
      compras.add(compra);
    }
    return compras;
  }

  List<DetalheDaCompra> carregarDetalhesDasCompras(
      List<DetalheDaCompraDto> detalhesDaCompraDto) {
    List<DetalheDaCompra> detalhesDaCompra = [];
    for (var detalheDaContaDto in detalhesDaCompraDto) {
      var detalheDaConta = DetalheDaCompra(
          cidadeDestino: detalheDaContaDto.cidadeDestino,
          cidadeOrigem: detalheDaContaDto.cidadeOrigem,
          dataChegada: detalheDaContaDto.dataChegada,
          dataSaida: detalheDaContaDto.dataSaida,
          empresaId: detalheDaContaDto.empresaId,
          id: detalheDaContaDto.id,
          ufDestino: detalheDaContaDto.ufDestino,
          ufOrigem: detalheDaContaDto.ufOrigem,
          voucherId: detalheDaContaDto.voucherId,
          voucherRealizado: detalheDaContaDto.voucherRealizado);
      detalhesDaCompra.add(detalheDaConta);
    }
    return detalhesDaCompra;
  }
}
