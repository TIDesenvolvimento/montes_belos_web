class GetAgenciasRequest {
  String? valorInseridoPeloUsuario;
  String? urlAmigavel;

  GetAgenciasRequest({this.valorInseridoPeloUsuario, this.urlAmigavel});

  GetAgenciasRequest.fromJson(Map<String, dynamic> json) {
    valorInseridoPeloUsuario = json['value'];
    urlAmigavel = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.valorInseridoPeloUsuario;
    data['url'] = this.urlAmigavel;
    return data;
  }
}
