import 'dart:convert';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class Cliente {
  int codigo;
  String nome;
  int tipoCliente;

  Cliente({required this.codigo, required this.nome, required this.tipoCliente});

  Map<String, dynamic> toJson() => {
        'codigo': codigo,
        'nome': nome,
        'tipoCliente': tipoCliente,
      };
}

class Vendedor {
  int codigo;
  String nome;
  double comissao;

  Vendedor({required this.codigo, required this.nome, required this.comissao});

  Map<String, dynamic> toJson() => {
        'codigo': codigo,
        'nome': nome,
        'comissao': comissao,
      };
}

class Veiculo {
  int codigo;
  String descricao;
  double valor;

  Veiculo({required this.codigo, required this.descricao, required this.valor});

  Map<String, dynamic> toJson() => {
        'codigo': codigo,
        'descricao': descricao,
        'valor': valor,
      };
}

class ItemPedido {
  int sequencial;
  String descricao;
  int quantidade;
  double valor;

  ItemPedido({
    required this.sequencial,
    required this.descricao,
    required this.quantidade,
    required this.valor,
  });

  Map<String, dynamic> toJson() => {
        'sequencial': sequencial,
        'descricao': descricao,
        'quantidade': quantidade,
        'valor': valor,
      };
}

class PedidoVenda {
  String codigo;
  DateTime data;
  double valorPedido;
  Cliente cliente;
  Vendedor vendedor;
  Veiculo veiculo;
  List<ItemPedido> items;

  PedidoVenda({
    required this.codigo,
    required this.data,
    required this.cliente,
    required this.vendedor,
    required this.veiculo,
    required this.items,
  }) : valorPedido = veiculo.valor + items.fold(0.0, (sum, item) => sum + (item.valor * item.quantidade));

  Map<String, dynamic> toJson() => {
        'codigo': codigo,
        'data': data.toIso8601String(),
        'valorPedido': valorPedido,
        'cliente': cliente.toJson(),
        'vendedor': vendedor.toJson(),
        'veiculo': veiculo.toJson(),
        'items': items.map((item) => item.toJson()).toList(),
      };
}

void main() async {
  var cliente = Cliente(codigo: 1, nome: "João Silva", tipoCliente: 2);
  var vendedor = Vendedor(codigo: 1, nome: "Carlos Gomes", comissao: 0.05);
  var veiculo = Veiculo(codigo: 101, descricao: "Opalla 6 Cilindros", valor:50000.00);
  var itens = [
    ItemPedido(sequencial: 1, descricao: "Tapete", quantidade: 2, valor: 50.00),
    ItemPedido(sequencial: 2, descricao: "Som automotivo", quantidade: 1, valor: 400.00),
    ItemPedido(sequencial: 3, descricao: "Farol neon", quantidade: 2, valor: 100.00)
  ];

  var pedido = PedidoVenda(
    codigo: "PV001",
    data: DateTime.now(),
    cliente: cliente,
    vendedor: vendedor,
    veiculo: veiculo,
    items: itens,
  );

  var encoder = const JsonEncoder.withIndent('  ');
  var jsonPedido = encoder.convert(pedido.toJson());

  final smtpServer = gmail('caua.rodrigues08@aluno.ifce.edu.br', 'yveo ktdm gjaw vzml');

  final message = Message()
    ..from = Address('caua.rodrigues08@aluno.ifce.edu.br', 'Cauã Rodrigues')
    ..recipients.add('taveira@ifce.edu.br')
    ..subject = 'PROVA PRATICA-DART'
    ..text = 'JSON proveniente da prova prática de Dart:\n\n$jsonPedido';

  try {
    final sendReport = await send(message, smtpServer);
    print('E-mail enviado com sucesso!\nJSON enviado:\n\n$jsonPedido');
  } on MailerException catch (e) {
    print('Erro ao enviar e-mail: ${e.toString()}');
  }
  
}
