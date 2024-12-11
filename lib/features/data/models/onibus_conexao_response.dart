import 'package:montesBelos/features/data/models/onibus_response.dart';
import 'package:montesBelos/features/data/models/purchase_request.dart';

class OnibusConexaoResponse {
  List<OnibusResponse>? frota;
  int? total;

  OnibusConexaoResponse({this.frota, this.total});

  OnibusConexaoResponse.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      frota = <OnibusResponse>[];
      json['list'].forEach((v) {
        frota!.add(new OnibusResponse.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.frota != null) {
      data['list'] = this.frota!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class BusLayout {
  List<Decks>? decks;

  BusLayout({this.decks});

  BusLayout.fromJson(Map<String, dynamic> json) {
    if (json['decks'] != null) {
      decks = <Decks>[];
      json['decks'].forEach((v) {
        decks!.add(new Decks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.decks != null) {
      data['decks'] = this.decks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Decks {
  String? id;
  int? number;
  List<Seats>? seats;

  Decks({this.id, this.number, this.seats});

  Decks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    number = json['number'];
    if (json['seats'] != null) {
      seats = <Seats>[];
      json['seats'].forEach((v) {
        seats!.add(new Seats.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['number'] = this.number;
    if (this.seats != null) {
      data['seats'] = this.seats!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Seats {
  String? id;
  String? x;
  String? y;
  String? number;
  String? label;
  String? type;
  Passenger? passenger;

  Seats(
      {this.id,
      this.x,
      this.y,
      this.number,
      this.label,
      this.type,
      this.passenger});

  Seats.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    x = json['x'];
    y = json['y'];
    number = json['number'];
    label = json['label'];
    type = json['type'];
    passenger = json['passenger'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['x'] = this.x;
    data['y'] = this.y;
    data['number'] = this.number;
    data['label'] = this.label;
    data['type'] = this.type;
    data['passenger'] = this.passenger;
    return data;
  }
}

class PriceInfo {
  double? basePrice;
  int? boardingPrice;
  double? serviceCharge;
  int? tollCharge;
  double? total;

  PriceInfo(
      {this.basePrice,
      this.boardingPrice,
      this.serviceCharge,
      this.tollCharge,
      this.total});

  PriceInfo.fromJson(Map<String, dynamic> json) {
    basePrice = json['basePrice'];
    boardingPrice = json['boardingPrice'];
    serviceCharge = json['serviceCharge'];
    tollCharge = json['tollCharge'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['basePrice'] = this.basePrice;
    data['boardingPrice'] = this.boardingPrice;
    data['serviceCharge'] = this.serviceCharge;
    data['tollCharge'] = this.tollCharge;
    data['total'] = this.total;
    return data;
  }
}
