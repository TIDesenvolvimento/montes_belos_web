class GetAgenciaResponse {
  int? id;
  String? name;
  String? uf;
  String? urlAmigavel;

  GetAgenciaResponse({this.id, this.name, this.uf, this.urlAmigavel});

  GetAgenciaResponse.fromJson(Map<String, dynamic> json) {
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