import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:montesBelos/core/utils/constants/strings.dart';

class SnackBarPersonalizado {
  SnackBar erroInternoNoServidorSnackBar(String mensagem) {
    return SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: snack_bar__texto_sucesso,
        message: mensagem.replaceAll(RegExp('Exception: '), ''),
        contentType: ContentType.failure,
      ),
    );
  }

  SnackBar erroSnackBar(String mensagem) {
    return SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: snack_bar__texto_atencao,
        message: mensagem.replaceAll(RegExp('Exception: '), ''),
        contentType: ContentType.failure,
      ),
    );
  }

  SnackBar sucessoSnackBar(String mensagem) {
    return SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: snack_bar__texto_sucesso,
        message: mensagem,
        contentType: ContentType.success,
      ),
    );
  }

  SnackBar atencaoSnackBar(String mensagem) {
    return SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: snack_bar__texto_atencao,
        message: mensagem.replaceAll(RegExp('Exception: '), ''),
        contentType: ContentType.warning,
      ),
    );
  }
}
