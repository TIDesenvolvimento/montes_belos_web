import 'package:dartz/dartz.dart';
import 'package:montesBelos/core/utils/constants/strings.dart';
import 'package:montesBelos/features/data/datasources/pagamento_pix_data_source.dart';
import 'package:montesBelos/features/data/models/pagamento_pix_response.dart';
import 'package:montesBelos/features/data/models/purchase_request.dart';
import 'package:montesBelos/features/domain/entities/pagamento_pix_status.dart';
import 'package:montesBelos/features/domain/repositories/pagamento_pix_repository.dart';

class PagamentoViaPixRepositoryImplementacao extends PagamentoViaPixRepository {
  PagamentoViaPixDataSource pagamentoViaPixDataSource;

  PagamentoViaPixRepositoryImplementacao(this.pagamentoViaPixDataSource);

  @override
  Future<Either<Exception, PagamentoViaPixStatus>> realizarPagamento(
      PurchaseRequest purchaseRequest) async {
    try {
      final result =
          await pagamentoViaPixDataSource.realizarPagamento(purchaseRequest);
      if (result.statusDeErro == "0") {
        return Right(carregarPagamentoViaPixStatus(result));
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

  PagamentoViaPixStatus carregarPagamentoViaPixStatus(
      PagamentoViaPixResponse pagamentoViaPixResponse) {
    return PagamentoViaPixStatus(
        errorType: pagamentoViaPixResponse.statusDeErro,
        pixQRCodeData: pagamentoViaPixResponse.pixQRCodeData,
        pixQRCodeUrl: pagamentoViaPixResponse.pixQRCodeUrl);
  }
}
