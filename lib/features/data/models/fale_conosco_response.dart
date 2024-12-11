class FaleConoscoResponse {
  String success;
  String mensagem;
  dynamic data;

  FaleConoscoResponse({
    required this.success,
    required this.mensagem,
    this.data,
  });

  factory FaleConoscoResponse.fromJson(Map<String, dynamic> json) {
    return FaleConoscoResponse(
      success: json['success'] as String,
      mensagem: json['mensagem'] as String,
      data: json['data'], // data pode ser null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'mensagem': mensagem,
      'data': data,
    };
  }
}
