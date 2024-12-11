import 'package:montesBelos/features/data/models/purchase_request.dart';

class Onibus {
  int? maxSelection;
  ViagemOriginal? viagem;
  BusLayout? busLayout;
  PriceInfo? priceInfo;

  Onibus({this.maxSelection, this.viagem, this.busLayout, this.priceInfo});

  Onibus.fromJson(Map<String, dynamic> json) {
    maxSelection = json['maxSelection'];
    viagem = json['travel'] != null
        ? new ViagemOriginal.fromJson(json['travel'])
        : null;
    busLayout = json['busLayout'] != null
        ? new BusLayout.fromJson(json['busLayout'])
        : null;
    priceInfo = json['priceInfo'] != null
        ? new PriceInfo.fromJson(json['priceInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['maxSelection'] = this.maxSelection;
    if (this.viagem != null) {
      data['travel'] = this.viagem!.toJson();
    }
    if (this.busLayout != null) {
      data['busLayout'] = this.busLayout!.toJson();
    }
    if (this.priceInfo != null) {
      data['priceInfo'] = this.priceInfo!.toJson();
    }
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
  List<Seat>? seats;

  Decks({this.id, this.number, this.seats});

  Decks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    number = json['number'];
    if (json['seats'] != null) {
      seats = <Seat>[];
      json['seats'].forEach((v) {
        seats!.add(new Seat.fromJson(v));
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

class PriceInfo {
  double? basePrice;
  double? boardingPrice;
  double? serviceCharge;
  double? tollCharge;
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
