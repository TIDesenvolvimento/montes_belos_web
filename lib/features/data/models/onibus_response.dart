import 'package:montesBelos/features/data/models/get_viagens_response.dart';

class OnibusResponse {
  int? maxSelection;
  ViagemDto? viagemDto;
  BusLayoutDto? busLayoutDto;
  PriceInfoDto? priceInfoDto;

  OnibusResponse(
      {this.maxSelection,
      this.viagemDto,
      this.busLayoutDto,
      this.priceInfoDto});

  OnibusResponse.fromJson(Map<String, dynamic> json) {
    maxSelection = json['maxSelection'];
    viagemDto =
        json['travel'] != null ? new ViagemDto.fromJson(json['travel']) : null;
    busLayoutDto = json['busLayout'] != null
        ? new BusLayoutDto.fromJson(json['busLayout'])
        : null;
    priceInfoDto = json['priceInfo'] != null
        ? new PriceInfoDto.fromJson(json['priceInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['maxSelection'] = this.maxSelection;
    if (this.viagemDto != null) {
      data['travel'] = this.viagemDto!.toJson();
    }
    if (this.busLayoutDto != null) {
      data['busLayout'] = this.busLayoutDto!.toJson();
    }
    if (this.priceInfoDto != null) {
      data['priceInfo'] = this.priceInfoDto!.toJson();
    }
    return data;
  }
}

class BusLayoutDto {
  List<DecksDto>? decksDto;

  BusLayoutDto({this.decksDto});

  BusLayoutDto.fromJson(Map<String, dynamic> json) {
    if (json['decks'] != null) {
      decksDto = <DecksDto>[];
      json['decks'].forEach((v) {
        decksDto!.add(new DecksDto.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.decksDto != null) {
      data['decks'] = this.decksDto!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DecksDto {
  String? id;
  int? number;
  List<SeatsDto>? seatsDto;

  DecksDto({this.id, this.number, this.seatsDto});

  DecksDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    number = json['number'];
    if (json['seats'] != null) {
      seatsDto = <SeatsDto>[];
      json['seats'].forEach((v) {
        seatsDto!.add(new SeatsDto.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['number'] = this.number;
    if (this.seatsDto != null) {
      data['seats'] = this.seatsDto!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SeatsDto {
  String? id;
  String? x;
  String? y;
  String? number;
  String? label;
  String? type;

  SeatsDto({
    this.id,
    this.x,
    this.y,
    this.number,
    this.label,
    this.type,
  });

  SeatsDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    x = json['x'];
    y = json['y'];
    number = json['number'];
    label = json['label'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['x'] = this.x;
    data['y'] = this.y;
    data['number'] = this.number;
    data['label'] = this.label;
    data['type'] = this.type;

    return data;
  }
}

class PriceInfoDto {
  double? basePrice;
  double? boardingPrice;
  double? serviceCharge;
  double? tollCharge;
  double? total;

  PriceInfoDto(
      {this.basePrice,
      this.boardingPrice,
      this.serviceCharge,
      this.tollCharge,
      this.total});

  PriceInfoDto.fromJson(Map<String, dynamic> json) {
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
