class FaleConoscoRequest {
  String nome;
  String email;
  String assunto;
  String mensagem;
  String emailDaEmpresaDestinataria;

  FaleConoscoRequest({
    required this.nome,
    required this.email,
    required this.assunto,
    required this.mensagem,
    required this.emailDaEmpresaDestinataria,
  });

  factory FaleConoscoRequest.fromJson(Map<String, dynamic> json) {
    return FaleConoscoRequest(
      nome: json['nome'] as String,
      email: json['email'] as String,
      assunto: json['assunto'] as String,
      mensagem: json['mensagem'] as String,
      emailDaEmpresaDestinataria: json['emailDaEmpresaDestinataria'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'email': email,
      'assunto': assunto,
      'mensagem': mensagem,
      'emailDaEmpresaDestinataria': emailDaEmpresaDestinataria,
    };
  }
}
