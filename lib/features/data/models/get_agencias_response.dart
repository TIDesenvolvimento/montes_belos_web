class GetAgenciasResponse {
  List<AgenciaDto>? agenciasDto;
  int? total;

  GetAgenciasResponse({this.agenciasDto, this.total});

  GetAgenciasResponse.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      agenciasDto = <AgenciaDto>[];
      json['list'].forEach((v) {
        agenciasDto!.add(new AgenciaDto.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.agenciasDto != null) {
      data['list'] = this.agenciasDto!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class AgenciaDto {
  int? id;
  String? name;
  String? uf;
  String? urlAmigavel;

  AgenciaDto({this.id, this.name, this.uf, this.urlAmigavel});

  AgenciaDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    uf = json['uf'];
    urlAmigavel = json['urlAmigavel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['uf'] = this.uf;
    data['urlAmigavel'] = this.urlAmigavel;
    return data;
  }
}
