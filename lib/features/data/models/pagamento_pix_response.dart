class PagamentoViaPixResponse {
  String? statusDeErro;
  String? pixQRCodeUrl;
  String? pixQRCodeData;

  PagamentoViaPixResponse(
      {this.statusDeErro, this.pixQRCodeUrl, this.pixQRCodeData});

  PagamentoViaPixResponse.fromJson(Map<String, dynamic> json) {
    statusDeErro = json['errorType'];
    pixQRCodeUrl = json['pixQRCodeUrl'];
    pixQRCodeData = json['pixQRCodeData'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorType'] = this.statusDeErro;
    data['pixQRCodeUrl'] = this.pixQRCodeUrl;
    data['pixQRCodeData'] = this.pixQRCodeData;
    return data;
  }
}
