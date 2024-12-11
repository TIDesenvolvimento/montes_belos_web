import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:montesBelos/features/presenter/utils/app_modulde.dart';
import 'package:montesBelos/features/presenter/utils/app_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyBSnGFabmFJFZaub59rKP6xirxH8EKKbjk",
        authDomain: "montesBelosweb.firebaseapp.com",
        projectId: "montesBelosweb",
        storageBucket: "montesBelosweb.firebasestorage.app",
        messagingSenderId: "612674684458",
        appId: "1:612674684458:web:c0272c98908413d5f0a553"),
  );

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: SystemUiOverlay.values);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  setUrlStrategy(PathUrlStrategy());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ModularApp(
      module: AppModule(),
      child: const AppWidget(),
    );
  }
}
