import 'dart:convert';

class Dependente {
  late String _nome;

  Dependente(String nome) {
    this._nome = nome;
  }

  String toJson() {
    return jsonEncode({'nome': _nome});
  }
}

class Funcionario {
  late String _nome;
  late List<Dependente> _dependentes;

  Funcionario(String nome, List<Dependente> dependentes) {
    this._nome = nome;
    this._dependentes = dependentes;
  }

  String toJson() {
    return jsonEncode({
      'nome': _nome,
      'dependentes': _dependentes.map((d) => jsonDecode(d.toJson())).toList(),
    });
  }
}

class EquipeProjeto {
  late String _nomeProjeto;
  late List<Funcionario> _funcionarios;

  EquipeProjeto(String nomeprojeto, List<Funcionario> funcionarios) {
    _nomeProjeto = nomeprojeto;
    _funcionarios = funcionarios;
  }

  String toJson() {
    var jsonString = jsonEncode({
      'nomeProjeto': _nomeProjeto,
      'funcionarios': _funcionarios.map((f) => jsonDecode(f.toJson())).toList(),
    });
    return JsonEncoder.withIndent('  ').convert(jsonDecode(jsonString));
  }
}

void main() {
  var dependente1 = Dependente("Maria");
  var dependente2 = Dependente("João");
  var dependente3 = Dependente("Ana");

  var funcionario1 = Funcionario("Carlos", [dependente1, dependente2]);
  var funcionario2 = Funcionario("Fernanda", [dependente3]);

  var funcionarios = [funcionario1, funcionario2];

  var equipeProjeto =
      EquipeProjeto("Desenvolvimento de Banco de Dados", funcionarios);

  print(equipeProjeto.toJson());
}
