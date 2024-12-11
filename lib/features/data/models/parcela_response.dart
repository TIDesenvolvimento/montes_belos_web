class ParcelaResponse {
  List<ParcelaDto>? parcelasDto;
  int? totalDeParcelas;

  ParcelaResponse({this.parcelasDto, this.totalDeParcelas});

  ParcelaResponse.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      parcelasDto = <ParcelaDto>[];
      json['list'].forEach((v) {
        parcelasDto!.add(new ParcelaDto.fromJson(v));
      });
    }
    totalDeParcelas = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.parcelasDto != null) {
      data['list'] = this.parcelasDto!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.totalDeParcelas;
    return data;
  }
}

class ParcelaDto {
  int? id;

  int? numeroParcelas;
  double? taxa;

  ParcelaDto({this.id, this.numeroParcelas, this.taxa});

  ParcelaDto.fromJson(Map<String, dynamic> json) {
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
