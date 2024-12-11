class PagamentoResponse {
  String? statusDeErro;

  PagamentoResponse({this.statusDeErro});

  PagamentoResponse.fromJson(Map<String, dynamic> json) {
    statusDeErro = json['errorType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorType'] = this.statusDeErro;
    return data;
  }
}
