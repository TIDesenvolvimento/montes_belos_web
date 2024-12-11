class CancelamentoRequest {
  int localizador;

  CancelamentoRequest({required this.localizador});

  Map<String, dynamic> toJson() {
    return {
      'localizador': localizador,
    };
  }

  factory CancelamentoRequest.fromJson(Map<String, dynamic> json) {
    return CancelamentoRequest(
      localizador: json['localizador'] as int,
    );
  }
}
