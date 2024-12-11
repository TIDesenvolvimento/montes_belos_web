import 'package:dartz/dartz.dart';
import 'package:montesBelos/core/utils/constants/strings.dart';
import 'package:montesBelos/features/data/datasources/pagamento_data_source.dart';
import 'package:montesBelos/features/data/models/purchase_request.dart';
import 'package:montesBelos/features/domain/repositories/pagamento_repository.dart';

class PagamentoRepositoryImplementacao extends PagamentoRepository {
  PagamentoDataSource pagamentoDataSource;

  PagamentoRepositoryImplementacao(this.pagamentoDataSource);

  @override
  Future<Either<Exception, String>> realizarPagamento(
      PurchaseRequest purchaseRequest) async {
    try {
      final result =
          await pagamentoDataSource.realizarPagamento(purchaseRequest);
      if (result.statusDeErro == "0") {
        return Right(result.statusDeErro!);
      }
      if (result.statusDeErro == "1") {
        return Left(Exception(resumo_da_compra__text_poltrona_ja_vendida));
      }
      if (result.statusDeErro == "4" || result.statusDeErro == "6") {
        return Left(Exception(pagamento__text_erro_ao_realizar_pagamento));
      }

      return Left(Exception(pagamento__text_erro_ao_realizar_pagamento));
    } on Exception {
      return Left(Exception(falha_interna_no_servidor));
    }
  }
}
