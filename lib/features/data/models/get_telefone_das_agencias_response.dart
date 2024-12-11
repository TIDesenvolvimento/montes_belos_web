class AgenciaData {
  final int id;
  final String nome;
  final String uf;
  final String fone;

  AgenciaData({
    required this.id,
    required this.nome,
    required this.uf,
    required this.fone,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'uf': uf,
      'fone': fone,
    };
  }

  factory AgenciaData.fromJson(Map<String, dynamic> json) {
    return AgenciaData(
      id: json['id'],
      nome: json['nome'],
      uf: json['uf'],
      fone: json['fone'],
    );
  }
}

class GetTelefoneDasAgenciasResponse {
  final String success;
  final String mensagem;
  final List<AgenciaData> data;

  GetTelefoneDasAgenciasResponse({
    required this.success,
    required this.mensagem,
    required this.data,
  });

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'mensagem': mensagem,
      'data': data.map((agencia) => agencia.toJson()).toList(),
    };
  }

  factory GetTelefoneDasAgenciasResponse.fromJson(Map<String, dynamic> json) {
    return GetTelefoneDasAgenciasResponse(
      success: json['success'],
      mensagem: json['mensagem'],
      data: (json['data'] as List)
          .map((item) => AgenciaData.fromJson(item))
          .toList(),
    );
  }
}
