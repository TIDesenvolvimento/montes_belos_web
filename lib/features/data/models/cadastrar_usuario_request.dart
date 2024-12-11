class NovoUsuarioRequest {
  String? nome;
  String? email;
  String? senha;
  String? idDaConta;
  int? tipoDaConta;

  NovoUsuarioRequest(
      {this.nome, this.email, this.senha, this.idDaConta, this.tipoDaConta});

  NovoUsuarioRequest.fromJson(Map<String, dynamic> json) {
    nome = json['nome'];
    email = json['email'];
    senha = json['senha'];
    idDaConta = json['idDaConta'];
    tipoDaConta = json['tipoDaConta'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this.nome;
    data['email'] = this.email;
    data['senha'] = this.senha;
    data['idDaConta'] = this.idDaConta;
    data['tipoDaConta'] = this.tipoDaConta;
    return data;
  }
}
