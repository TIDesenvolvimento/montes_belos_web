import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;

class RedirectPage extends StatefulWidget {
  @override
  _RedirectPageState createState() => _RedirectPageState();
}

class _RedirectPageState extends State<RedirectPage> {
  @override
  void initState() {
    super.initState();
    _redirectToPlatform();
  }

  void _redirectToPlatform() {
    final userAgent = html.window.navigator.userAgent.toLowerCase();

    if (userAgent.contains("android")) {
      html.window.location.href =
          "https://play.google.com/store/apps/details?id=br.com.tisistema.montesBelos";
    } else if (userAgent.contains("iphone") || userAgent.contains("ipad")) {
      html.window.location.href =
          "https://apps.apple.com/us/app/montes-belos/id6453521975";
    } else {
      html.window.location.href = "https://montesBelos.com.br";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Redirecionando...'),
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
