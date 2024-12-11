class LoginStatus {
  late bool usuarioLogado = false;
  late String mensagem = "";
  late int statusDoLogin = 0;
  late String url = "";

  LoginStatus(
      {required this.usuarioLogado,
      required this.mensagem,
      required this.statusDoLogin,
      required this.url});
}
