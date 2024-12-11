import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class DialogDeCarregamento {
  Future<void> exibirDialogDeCarregamento(BuildContext context) async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(
              child: SpinKitChasingDots(
            size: 60,
            color: Colors.white,
          ));
        });
  }

  esconderDialogDeCarregamento(BuildContext context) {
    Navigator.of(context).pop();
  }
}
