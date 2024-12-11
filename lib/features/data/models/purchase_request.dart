class PurchaseRequest {
  ViagemOriginal? originalTravelForward;
  ViagemOriginal? originalTravelBackward;
  int? quantPoltronasBackward;
  int? quantPoltronasForward;
  Trecho? origin;
  Trecho? destination;
  ClienteWeb? clienteWeb;
  List<SentidoDaRota>? forwards;
  List<SentidoDaRota>? backwards;
  double? totalPoltronasForward;
  double? totalTaxaEmbarqueForward;
  double? totalPoltronasBackward;
  double? totalTaxaEmbarqueBackward;
  double? totalPoltronas;
  double? totalTaxaServico;
  double? totalTaxaEmbarque;
  double? total;
  double? valorJuros;
  double? totalComJuros;
  int? installments;
  String? cardEncryptedData;
  String? paymentMethod;
  KreditKard? kreditKard;
  int? quantidadeDePoltronasDaConexao;
  bool? abrindoTeclado;

  PurchaseRequest(
      {this.originalTravelForward,
      this.originalTravelBackward,
      this.quantPoltronasBackward,
      this.quantPoltronasForward,
      this.origin,
      this.destination,
      this.clienteWeb,
      this.forwards,
      this.backwards,
      this.totalPoltronasForward,
      this.totalTaxaEmbarqueForward,
      this.totalPoltronasBackward,
      this.totalTaxaEmbarqueBackward,
      this.totalPoltronas,
      this.totalTaxaServico,
      this.totalTaxaEmbarque,
      this.total,
      this.valorJuros,
      this.totalComJuros,
      this.installments,
      this.cardEncryptedData,
      this.paymentMethod,
      this.kreditKard,
      this.quantidadeDePoltronasDaConexao,
      this.abrindoTeclado});

  PurchaseRequest.fromJson(Map<String, dynamic> json) {
    if (json['originalTravelForward'] != null) {
      originalTravelForward =
          ViagemOriginal.fromJson(json['originalTravelForward']);
    }

    if (json['originalTravelBackward'] != null) {
      originalTravelBackward =
          ViagemOriginal.fromJson(json['originalTravelBackward']);
    }

    if (json['quantPoltronasBackward'] != null) {
      quantPoltronasBackward = json['quantPoltronasBackward'];
    }

    if (json['quantPoltronasForward'] != null) {
      quantPoltronasForward = json['quantPoltronasForward'];
    }

    if (json['origin'] != null) {
      origin = Trecho.fromJson(json['origin']);
    }

    if (json['destination'] != null) {
      destination = Trecho.fromJson(json['destination']);
    }

    if (json['clienteWeb'] != null) {
      clienteWeb = ClienteWeb.fromJson(json['clienteWeb']);
    }

    if (json['forwards'] != null) {
      forwards = (json['forwards'] as List)
          .map((v) => SentidoDaRota.fromJson(v))
          .toList();
    }

    if (json['backwards'] != null) {
      backwards = (json['backwards'] as List)
          .map((v) => SentidoDaRota.fromJson(v))
          .toList();
    }

    if (json['totalPoltronasForward'] != null) {
      totalPoltronasForward = json['totalPoltronasForward'];
    }

    if (json['totalTaxaEmbarqueForward'] != null) {
      totalTaxaEmbarqueForward = json['totalTaxaEmbarqueForward'];
    }

    if (json['totalPoltronasBackward'] != null) {
      totalPoltronasBackward = json['totalPoltronasBackward'];
    }

    if (json['totalTaxaEmbarqueBackward'] != null) {
      totalTaxaEmbarqueBackward = json['totalTaxaEmbarqueBackward'];
    }

    if (json['totalPoltronas'] != null) {
      totalPoltronas = json['totalPoltronas'];
    }

    if (json['totalTaxaServico'] != null) {
      totalTaxaServico = json['totalTaxaServico'];
    }

    if (json['totalTaxaEmbarque'] != null) {
      totalTaxaEmbarque = json['totalTaxaEmbarque'];
    }

    if (json['total'] != null) {
      total = json['total'];
    }

    if (json['valorJuros'] != null) {
      valorJuros = json['valorJuros'];
    }

    if (json['totalComJuros'] != null) {
      totalComJuros = json['totalComJuros'];
    }

    if (json['installments'] != null) {
      installments = json['installments'];
    }

    if (json['cardEncryptedData'] != null) {
      cardEncryptedData = json['cardEncryptedData'];
    }

    if (json['paymentMethod'] != null) {
      paymentMethod = json['paymentMethod'];
    }

    if (json['kreditKard'] != null) {
      kreditKard = KreditKard.fromJson(json['kreditKard']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['originalTravelForward'] = this.originalTravelForward?.toJson();

    if (originalTravelBackward != null) {
      data['originalTravelBackward'] = originalTravelBackward!.toJson();
    }

    if (quantPoltronasBackward != null) {
      data['quantPoltronasBackward'] = quantPoltronasBackward;
    }
    data['quantPoltronasForward'] = this.quantPoltronasForward;

    data['origin'] = this.origin!.toJson();

    data['destination'] = this.destination?.toJson();

    data['clienteWeb'] = this.clienteWeb?.toJson();

    data['forwards'] = this.forwards?.map((v) => v.toJson()).toList();

    if (backwards != null && backwards!.isNotEmpty) {
      data['backwards'] = backwards!.map((v) => v.toJson()).toList();
    }

    data['totalPoltronasForward'] = this.totalPoltronasForward;

    if (totalTaxaEmbarqueForward != null) {
      data['totalTaxaEmbarqueForward'] = totalTaxaEmbarqueForward;
    }

    if (totalPoltronasBackward != null) {
      data['totalPoltronasBackward'] = totalPoltronasBackward;
    }
    if (totalTaxaEmbarqueBackward != null) {
      data['totalTaxaEmbarqueBackward'] = totalTaxaEmbarqueBackward;
    }

    data['totalPoltronas'] = this.totalPoltronas;
    data['totalTaxaServico'] = this.totalTaxaServico;
    data['totalTaxaEmbarque'] = this.totalTaxaEmbarque;
    data['total'] = this.total;

    if (valorJuros != null) {
      data['valorJuros'] = valorJuros;
    }

    if (totalComJuros != null) {
      data['totalComJuros'] = totalComJuros;
    }

    data['installments'] = this.installments;
    data['cardEncryptedData'] = this.cardEncryptedData;
    data['paymentMethod'] = this.paymentMethod;
    if (this.kreditKard != null) {
      data['kreditKard'] = this.kreditKard!.toJson();
    }
    return data;
  }
}

class ViagemOriginal {
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

  ViagemOriginal(
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

  ViagemOriginal.fromJson(Map<String, dynamic> json) {
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

class Trecho {
  int? id;
  String? name;
  String? uf;
  String? urlAmigavel;
  String? label;

  Trecho({this.id, this.name, this.uf, this.urlAmigavel, this.label});

  Trecho.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    uf = json['uf'];
    urlAmigavel = json['urlAmigavel'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['uf'] = this.uf;
    data['urlAmigavel'] = this.urlAmigavel;
    data['label'] = this.label;
    return data;
  }
}

class ClienteWeb {
  int? id;
  int? legacyId;
  bool? deleted;
  String? nome;
  String? tipoPessoa;
  String? cpf;
  String? rg;
  String? ufRg;
  String? orgaoEmissorRg;
  String? cnpj;
  String? email;
  String? fone;
  String? senha;
  String? cep;
  String? uf;
  String? localidade;
  String? bairro;
  String? logradouro;
  String? complemento;
  String? dataNascimento;
  String? dataCadastro;
  bool? ativo;
  String? tokenAtivacao;
  String? origem;
  bool? concordaTermos;
  String? umaskedFone;
  String? realClass;
  String? tokenClienteWeb;

  ClienteWeb(
      {this.id,
      this.legacyId,
      this.deleted,
      this.nome,
      this.tipoPessoa,
      this.cpf,
      this.rg,
      this.ufRg,
      this.orgaoEmissorRg,
      this.cnpj,
      this.email,
      this.fone,
      this.senha,
      this.cep,
      this.uf,
      this.localidade,
      this.bairro,
      this.logradouro,
      this.complemento,
      this.dataNascimento,
      this.dataCadastro,
      this.ativo,
      this.tokenAtivacao,
      this.origem,
      this.concordaTermos,
      this.umaskedFone,
      this.realClass,
      this.tokenClienteWeb});

  ClienteWeb.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    legacyId = json['legacy_id'];
    deleted = json['deleted'];
    nome = json['nome'];
    tipoPessoa = json['tipoPessoa'];
    cpf = json['cpf'];
    rg = json['rg'];
    ufRg = json['ufRg'];
    orgaoEmissorRg = json['orgaoEmissorRg'];
    cnpj = json['cnpj'];
    email = json['email'];
    fone = json['fone'];
    senha = json['senha'];
    cep = json['cep'];
    uf = json['uf'];
    localidade = json['localidade'];
    bairro = json['bairro'];
    logradouro = json['logradouro'];
    complemento = json['complemento'];
    dataNascimento = json['dataNascimento'];
    dataCadastro = json['dataCadastro'];
    if (json['ativo'] == 0 || json['ativo'] == true) {
      ativo = true;
    } else {
      ativo = false;
    }
    tokenAtivacao = json['tokenAtivacao'];
    origem = json['origem'];
    if (json['concordaTermos'] == 0 || json['concordaTermos'] == true) {
      concordaTermos = true;
    } else {
      concordaTermos = false;
    }
    umaskedFone = json['umaskedFone'];
    realClass = json['realClass'];
    tokenClienteWeb = json['tokenClienteWeb'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['deleted'] = false;
    data['nome'] = this.nome;
    data['tipoPessoa'] = this.tipoPessoa;
    data['cpf'] = this.cpf;
    data['rg'] = this.rg;
    data['ufRg'] = this.ufRg;
    data['orgaoEmissorRg'] = this.orgaoEmissorRg;
    data['cnpj'] = this.cnpj;
    data['email'] = this.email;
    data['fone'] = this.fone;
    data['senha'] = this.senha;
    data['cep'] = this.cep;
    data['uf'] = this.uf;
    data['localidade'] = this.localidade;
    data['bairro'] = this.bairro;
    data['logradouro'] = this.logradouro;
    data['complemento'] = this.complemento;
    data['dataNascimento'] = this.dataNascimento;
    data['dataCadastro'] = this.dataCadastro;
    data['ativo'] = this.ativo;

    data['origem'] = this.origem;

    data['concordaTermos'] = this.concordaTermos;
    data['umaskedFone'] = this.umaskedFone;
    data['realClass'] = this.realClass;
    data['tokenClienteWeb'] = this.tokenClienteWeb;
    return data;
  }
}

class SentidoDaRota {
  Trecho? origin;
  Trecho? destination;
  ViagemOriginal? travel;
  List<Seat>? seats;
  double? totalPoltronas;
  double? totalTaxaServico;
  double? totalTaxaEmbarque;
  double? total;

  SentidoDaRota(
      {this.origin,
      this.destination,
      this.travel,
      this.seats,
      this.totalPoltronas,
      this.totalTaxaServico,
      this.totalTaxaEmbarque,
      this.total});

  SentidoDaRota.fromJson(Map<String, dynamic> json) {
    origin =
        json['origin'] != null ? new Trecho.fromJson(json['origin']) : null;
    destination = json['destination'] != null
        ? new Trecho.fromJson(json['destination'])
        : null;
    travel = json['travel'] != null
        ? new ViagemOriginal.fromJson(json['travel'])
        : null;
    if (json['seats'] != null) {
      seats = <Seat>[];
      json['seats'].forEach((v) {
        seats!.add(new Seat.fromJson(v));
      });
    }
    totalPoltronas = json['totalPoltronas'];
    totalTaxaServico = json['totalTaxaServico'];
    totalTaxaEmbarque = json['totalTaxaEmbarque'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.origin != null) {
      data['origin'] = this.origin!.toJson();
    }
    if (this.destination != null) {
      data['destination'] = this.destination!.toJson();
    }
    if (this.travel != null) {
      data['travel'] = this.travel!.toJson();
    }
    if (this.seats != null) {
      data['seats'] = this.seats!.map((v) => v.toJson()).toList();
    }
    data['totalPoltronas'] = this.totalPoltronas;
    data['totalTaxaServico'] = this.totalTaxaServico;
    data['totalTaxaEmbarque'] = this.totalTaxaEmbarque;
    data['total'] = this.total;
    return data;
  }
}

class Seat {
  String? id;
  String? x;
  String? y;
  String? number;
  String? label;
  String? type;
  Passenger? passenger;
  int? index;

  Seat(
      {this.id,
      this.x,
      this.y,
      this.number,
      this.label,
      this.type,
      this.passenger,
      this.index});

  Seat.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    x = json['x'];
    y = json['y'];
    number = json['number'];
    label = json['label'];
    type = json['type'];
    passenger = json['passenger'] != null
        ? new Passenger.fromJson(json['passenger'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['x'] = this.x;
    data['y'] = this.y;
    data['number'] = this.number;
    data['label'] = this.label;
    data['type'] = this.type;
    if (this.passenger != null) {
      data['passenger'] = this.passenger!.toJson();
    }
    return data;
  }
}

class Passenger {
  String? name;
  String? fone;
  String? docNumber;
  String? docDispatcher;
  String? docUf;

  Passenger(
      {this.name, this.fone, this.docNumber, this.docDispatcher, this.docUf});

  Passenger.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    fone = json['fone'];
    docNumber = json['docNumber'];
    docDispatcher = json['docDispatcher'];
    docUf = json['docUf'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['name'] = this.name;
    data['fone'] = this.fone;
    data['docNumber'] = this.docNumber;
    data['docDispatcher'] = this.docDispatcher;
    data['docUf'] = this.docUf;
    return data;
  }
}

class KreditKard {
  String? status;
  String? bin;
  String? last4;
  String? expirationDate;
  String? holderName;

  KreditKard(
      {this.status,
      this.bin,
      this.last4,
      this.expirationDate,
      this.holderName});

  KreditKard.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    bin = json['bin'];
    last4 = json['last4'];
    expirationDate = json['expirationDate'];
    holderName = json['holderName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['bin'] = this.bin;
    data['last4'] = this.last4;
    data['expirationDate'] = this.expirationDate;
    data['holderName'] = this.holderName;
    return data;
  }
}
