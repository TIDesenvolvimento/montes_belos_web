class AtualizarClienteResquest {
  int? id;
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
  String? tokenClienteWeb;

  AtualizarClienteResquest(
      {this.id,
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
      this.tokenClienteWeb});

  AtualizarClienteResquest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
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
    ativo = json['ativo'];
    tokenAtivacao = json['tokenAtivacao'];
    origem = json['origem'];
    concordaTermos = json['concordaTermos'];
    umaskedFone = json['umaskedFone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
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
    data['tokenAtivacao'] = this.tokenAtivacao;
    data['origem'] = this.origem;
    data['concordaTermos'] = this.concordaTermos;
    data['umaskedFone'] = this.umaskedFone;
    return data;
  }
}
