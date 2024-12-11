class PagamentoViaPixStatus {
  String? errorType;
  String? pixQRCodeUrl;
  String? pixQRCodeData;

  PagamentoViaPixStatus(
      {this.errorType, this.pixQRCodeUrl, this.pixQRCodeData});

  PagamentoViaPixStatus.fromJson(Map<String, dynamic> json) {
    errorType = json['errorType'];
    pixQRCodeUrl = json['pixQRCodeUrl'];
    pixQRCodeData = json['pixQRCodeData'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorType'] = this.errorType;
    data['pixQRCodeUrl'] = this.pixQRCodeUrl;
    data['pixQRCodeData'] = this.pixQRCodeData;
    return data;
  }
}
