class ParcelaStatus {
  List<Parcela>? parcelas;
  int? totalDeParcelas;

  ParcelaStatus({this.parcelas, this.totalDeParcelas});

  ParcelaStatus.fromJson(Map<String, dynamic> json) {
    if (json['juros'] != null) {
      parcelas = <Parcela>[];
      json['juros'].forEach((v) {
        parcelas!.add(new Parcela.fromJson(v));
      });
    }
    totalDeParcelas = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.parcelas != null) {
      data['juros'] = this.parcelas!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.totalDeParcelas;
    return data;
  }
}

class Parcela {
  int? id;
  int? numeroParcelas;
  double? taxa;

  Parcela({this.id, this.numeroParcelas, this.taxa});

  Parcela.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    numeroParcelas = json['numeroParcelas'];
    taxa = json['taxa'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['numeroParcelas'] = this.numeroParcelas;
    data['taxa'] = this.taxa;
    return data;
  }
}
