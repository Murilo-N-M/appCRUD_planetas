class Planeta {
  int? id;
  String nome;
  String? apelido;
  double tamanho;
  double massa;
  double distanciaSolar;
  String? funFact;

// Construtor da classe Planeta
  Planeta({
    this.id,
    required this.nome,
    this.apelido,
    required this.tamanho,
    required this.massa,
    required this.distanciaSolar,
    this.funFact,
  });

// Construtor alternativo vazio
  Planeta.vazio()
      : nome = '',
        apelido = '',
        tamanho = 0,
        massa = 0,
        distanciaSolar = 0,
        funFact = '';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'apelido': apelido,
      'tamanho': tamanho,
      'massa': massa,
      'distanciaSolar': distanciaSolar,
      'funFact': funFact,
    };
  }

  factory Planeta.fromMap(Map<String, dynamic> map) {
    return Planeta(
      id: map['id'],
      nome: map['nome'],
      apelido: map['apelido'],
      tamanho: map['tamanho'],
      massa: map['massa'],
      distanciaSolar: map['distanciaSolar'],
      funFact: map['funFact'],
    );
  }
}
