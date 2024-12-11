class NovoUsuarioResponse {
  String? sucesso;
  String? mensagem;
  String? data;

  NovoUsuarioResponse({this.sucesso, this.mensagem, this.data});

  NovoUsuarioResponse.fromJson(Map<String, dynamic> json) {
    sucesso = json['success'];
    mensagem = json['mensagem'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.sucesso;
    data['mensagem'] = this.mensagem;
    data['data'] = this.data;
    return data;
  }
}
