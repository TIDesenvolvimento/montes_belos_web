class LoginRequest {
  String? email;
  String? senha;
  String? idDaConta;
  int? tipoDaConta;

  LoginRequest({this.email, this.senha, this.idDaConta, this.tipoDaConta});

  LoginRequest.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    senha = json['senha'];
    idDaConta = json['idDaConta'];
    tipoDaConta = json['tipoDaConta'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['senha'] = this.senha;
    data['idDaConta'] = this.idDaConta;
    data['tipoDaConta'] = this.tipoDaConta;
    return data;
  }
}
