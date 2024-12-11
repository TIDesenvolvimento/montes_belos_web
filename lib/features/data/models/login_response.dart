import 'package:montesBelos/features/data/models/purchase_request.dart';

class LoginResponse {
  String? success;
  String? mensagem;
  Data? data;

  LoginResponse({this.success, this.mensagem, this.data});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    mensagem = json['mensagem'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['mensagem'] = this.mensagem;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  ClienteWeb? clienteWeb;
  String? token;

  Data({this.clienteWeb, this.token});

  Data.fromJson(Map<String, dynamic> json) {
    clienteWeb = json['clienteWeb'] != null
        ? new ClienteWeb.fromJson(json['clienteWeb'])
        : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.clienteWeb != null) {
      data['clienteWeb'] = this.clienteWeb!.toJson();
    }
    data['token'] = this.token;
    return data;
  }
}
