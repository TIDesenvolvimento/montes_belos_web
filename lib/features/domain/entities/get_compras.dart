class GetCompras {
  List<Compra>? compras;
  int? total;

  GetCompras({this.compras, this.total});

  GetCompras.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      compras = <Compra>[];
      json['list'].forEach((v) {
        compras!.add(new Compra.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.compras != null) {
      data['list'] = this.compras!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class Compra {
  int? id;
  String? dataCriacao;
  double? valor;
  String? status;
  List<DetalheDaCompra>? detalhesDaCompra;
  bool? expanded;

  Compra(
      {this.id,
      this.dataCriacao,
      this.valor,
      this.status,
      this.detalhesDaCompra,
      this.expanded});

  Compra.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dataCriacao = json['dataCriacao'];
    valor = json['valor'];
    status = json['status'];
    expanded = false;
    if (json['itens'] != null) {
      detalhesDaCompra = <DetalheDaCompra>[];
      json['itens'].forEach((v) {
        detalhesDaCompra!.add(new DetalheDaCompra.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['dataCriacao'] = this.dataCriacao;
    data['valor'] = this.valor;
    data['status'] = this.status;
    if (this.detalhesDaCompra != null) {
      data['itens'] = this.detalhesDaCompra!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DetalheDaCompra {
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

  DetalheDaCompra(
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

  DetalheDaCompra.fromJson(Map<String, dynamic> json) {
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
