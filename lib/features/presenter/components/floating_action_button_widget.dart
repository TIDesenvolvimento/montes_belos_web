import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:montesBelos/features/presenter/utils/whats_app_helper.dart';

class BotaoFlutuante extends StatelessWidget {
  const BotaoFlutuante({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 50, bottom: 50),
      child: FloatingActionButton(
        onPressed: () {
          WhatsAppHelper().direcionarParaOWhatsapp();
        },
        backgroundColor: Color.fromARGB(255, 0, 192, 64),
        child: Icon(
          FontAwesomeIcons.whatsapp,
          size: 24,
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
      ),
    );
  }
}
