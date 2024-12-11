class RedefinirSenhaRequest {
  String? email;
  String? senhaAtual;
  String? novaSenha;
  String? novaSenhaConfirmada;

  RedefinirSenhaRequest(
      {this.email, this.senhaAtual, this.novaSenha, this.novaSenhaConfirmada});

  RedefinirSenhaRequest.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    senhaAtual = json['currentPassword'];
    novaSenha = json['newPassword'];
    novaSenhaConfirmada = json['newPasswordConfirmation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['currentPassword'] = this.senhaAtual;
    data['newPassword'] = this.novaSenha;
    data['newPasswordConfirmation'] = this.novaSenhaConfirmada;
    return data;
  }
}
