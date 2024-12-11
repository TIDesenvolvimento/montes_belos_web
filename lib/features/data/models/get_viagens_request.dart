class GetViagensRequest {
  String? data;
  String? urlAmigavelOrigem;
  String? urlAmigavelDestino;

  GetViagensRequest(
      {this.data, this.urlAmigavelOrigem, this.urlAmigavelDestino});

  GetViagensRequest.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    urlAmigavelOrigem = json['urlAmigavelOrigem'];
    urlAmigavelDestino = json['urlAmigavelDestino'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    data['urlAmigavelOrigem'] = this.urlAmigavelOrigem;
    data['urlAmigavelDestino'] = this.urlAmigavelDestino;
    return data;
  }
}
