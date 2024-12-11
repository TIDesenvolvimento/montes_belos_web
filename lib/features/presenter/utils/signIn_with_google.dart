import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:montesBelos/features/presenter/model/usuario.dart';

final GoogleSignIn googleSignIn = GoogleSignIn(
  clientId:
      '612674684458-r6atrbmqpn3hei1mnfrshpes0u1uliaj.apps.googleusercontent.com',
);

Future<Usuario> signInWithGoogle(BuildContext context) async {
  try {
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser != null) {
      return Usuario(
        email: googleUser.email,
        id: googleUser.id,
        nome: googleUser.displayName ?? '',
        tipoDaConta: 1,
      );
    } else {
      throw Exception("Login failed");
    }
  } catch (e) {
    return Usuario();
  }
}
