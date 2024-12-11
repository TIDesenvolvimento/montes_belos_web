class GetViagensResponse {
  List<ViagemDto>? viagensDto;
  int? total;

  GetViagensResponse({this.viagensDto, this.total});

  GetViagensResponse.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      viagensDto = <ViagemDto>[];
      json['list'].forEach((v) {
        viagensDto!.add(new ViagemDto.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.viagensDto != null) {
      data['list'] = this.viagensDto!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class ViagemDto {
  int? date;
  int? origin;
  String? originName;
  String? originUf;
  int? destination;
  String? destinationName;
  String? destinationUf;
  String? departure;
  String? arrival;
  String? service;
  int? busCompany;
  String? busCompanyName;
  String? urlLogo;
  int? freeSeats;
  double? price;
  double? toll;
  double? priceRate;
  double? otherTaxes;
  double? discount;
  double? boardingFee;
  double? serviceTax;
  String? busType;
  String? message;
  int? id;
  String? time;
  bool? isConexao;
  int? idConexao;
  int? sequenciaConexao;
  int? horarioSaidaConexao;
  double? icmsValue;

  ViagemDto(
      {this.date,
      this.origin,
      this.originName,
      this.originUf,
      this.destination,
      this.destinationName,
      this.destinationUf,
      this.departure,
      this.arrival,
      this.service,
      this.busCompany,
      this.busCompanyName,
      this.urlLogo,
      this.freeSeats,
      this.price,
      this.toll,
      this.priceRate,
      this.otherTaxes,
      this.discount,
      this.boardingFee,
      this.serviceTax,
      this.busType,
      this.message,
      this.id,
      this.time,
      this.isConexao,
      this.idConexao,
      this.sequenciaConexao,
      this.horarioSaidaConexao,
      this.icmsValue});

  ViagemDto.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    origin = json['origin'];
    originName = json['originName'];
    originUf = json['originUf'];
    destination = json['destination'];
    destinationName = json['destinationName'];
    destinationUf = json['destinationUf'];
    departure = json['departure'];
    arrival = json['arrival'];
    service = json['service'];
    busCompany = json['busCompany'];
    busCompanyName = json['busCompanyName'];
    urlLogo = json['urlLogo'];
    freeSeats = json['freeSeats'];
    price = json['price'];
    toll = json['toll'];
    priceRate = json['priceRate'];
    otherTaxes = json['otherTaxes'];
    discount = json['discount'];
    boardingFee = json['boardingFee'];
    serviceTax = json['serviceTax'];
    busType = json['busType'];
    message = json['message'];
    id = json['id'];
    time = json['time'];
    isConexao = json['isConexao'];
    idConexao = json['idConexao'];
    sequenciaConexao = json['sequenciaConexao'];
    horarioSaidaConexao = json['horarioSaidaConexao'];
    icmsValue = json['icmsValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['origin'] = this.origin;
    data['originName'] = this.originName;
    data['originUf'] = this.originUf;
    data['destination'] = this.destination;
    data['destinationName'] = this.destinationName;
    data['destinationUf'] = this.destinationUf;
    data['departure'] = this.departure;
    data['arrival'] = this.arrival;
    data['service'] = this.service;
    data['busCompany'] = this.busCompany;
    data['busCompanyName'] = this.busCompanyName;
    data['urlLogo'] = this.urlLogo;
    data['freeSeats'] = this.freeSeats;
    data['price'] = this.price;
    data['toll'] = this.toll;
    data['priceRate'] = this.priceRate;
    data['otherTaxes'] = this.otherTaxes;
    data['discount'] = this.discount;
    data['boardingFee'] = this.boardingFee;
    data['serviceTax'] = this.serviceTax;
    data['busType'] = this.busType;
    data['message'] = this.message;
    data['id'] = this.id;
    data['time'] = this.time;
    data['isConexao'] = this.isConexao;
    data['idConexao'] = this.idConexao;
    data['sequenciaConexao'] = this.sequenciaConexao;
    data['horarioSaidaConexao'] = this.horarioSaidaConexao;
    data['icmsValue'] = this.icmsValue;
    return data;
  }
}
