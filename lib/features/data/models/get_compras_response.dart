class GetComprasReponse {
  List<ComprasDto>? comprasDto;
  int? total;

  GetComprasReponse({this.comprasDto, this.total});

  GetComprasReponse.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      comprasDto = <ComprasDto>[];
      json['list'].forEach((v) {
        comprasDto!.add(new ComprasDto.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.comprasDto != null) {
      data['list'] = this.comprasDto!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class ComprasDto {
  int? id;
  String? dataCriacao;
  double? valor;
  String? status;
  List<DetalheDaCompraDto>? detalhesDaCompraDto;

  ComprasDto(
      {this.id,
      this.dataCriacao,
      this.valor,
      this.status,
      this.detalhesDaCompraDto});

  ComprasDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dataCriacao = json['dataCriacao'];
    valor = json['valor'];
    status = json['status'];
    if (json['itens'] != null) {
      detalhesDaCompraDto = <DetalheDaCompraDto>[];
      json['itens'].forEach((v) {
        detalhesDaCompraDto!.add(new DetalheDaCompraDto.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['dataCriacao'] = this.dataCriacao;
    data['valor'] = this.valor;
    data['status'] = this.status;
    if (this.detalhesDaCompraDto != null) {
      data['itens'] = this.detalhesDaCompraDto!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DetalheDaCompraDto {
  int? id;
  String? cidadeOrigem;
  String? ufOrigem;
  String? cidadeDestino;
  String? ufDestino;
  String? dataSaida;
  String? dataChegada;
  int? voucherId;
  int? empresaId;
  bool? voucherRealizado;

  DetalheDaCompraDto(
      {this.id,
      this.cidadeOrigem,
      this.ufOrigem,
      this.cidadeDestino,
      this.ufDestino,
      this.dataSaida,
      this.dataChegada,
      this.voucherId,
      this.empresaId,
      this.voucherRealizado});

  DetalheDaCompraDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cidadeOrigem = json['cidadeOrigem'];
    ufOrigem = json['ufOrigem'];
    cidadeDestino = json['cidadeDestino'];
    ufDestino = json['ufDestino'];
    dataSaida = json['dataSaida'];
    dataChegada = json['dataChegada'];
    voucherId = json['voucherId'];
    empresaId = json['empresaId'];
    voucherRealizado = json['voucherRealizado'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cidadeOrigem'] = this.cidadeOrigem;
    data['ufOrigem'] = this.ufOrigem;
    data['cidadeDestino'] = this.cidadeDestino;
    data['ufDestino'] = this.ufDestino;
    data['dataSaida'] = this.dataSaida;
    data['dataChegada'] = this.dataChegada;
    data['voucherId'] = this.voucherId;
    data['empresaId'] = this.empresaId;
    data['voucherRealizado'] = this.voucherRealizado;
    return data;
  }
}
