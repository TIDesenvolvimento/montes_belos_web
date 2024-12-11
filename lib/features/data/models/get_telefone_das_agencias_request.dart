class GetTelefoneDasAgenciasRequest {
  String uf;
  int empId;

  GetTelefoneDasAgenciasRequest({required this.uf, required this.empId});

  Map<String, dynamic> toJson() {
    return {
      'uf': uf,
      'empId': empId,
    };
  }

  factory GetTelefoneDasAgenciasRequest.fromJson(Map<String, dynamic> json) {
    return GetTelefoneDasAgenciasRequest(
      uf: json['uf'],
      empId: json['empId'],
    );
  }
}
