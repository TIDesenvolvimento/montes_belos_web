class OnibusRequest {
  String? data;
  int? idOrigem;
  int? idDestino;
  int? idViacao;
  int? id;

  OnibusRequest(
      {this.data, this.idOrigem, this.idDestino, this.idViacao, this.id});

  OnibusRequest.fromJson(Map<String, dynamic> json) {
    data = json['date'];
    idOrigem = json['origin'];
    idDestino = json['destination'];
    idViacao = json['busCompany'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.data;
    data['origin'] = this.idOrigem;
    data['destination'] = this.idDestino;
    data['busCompany'] = this.idViacao;
    data['id'] = this.id;
    return data;
  }
}
