import 'dart:io';
import 'package:sqlite3/sqlite3.dart';

void main() {
  final db = sqlite3.open('alunos.db');

  // Cria tabela se não existir
  db.execute('''
    CREATE TABLE IF NOT EXISTS TB_ALUNO (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL
    );
  ''');

  while (true) {
    print('\n--- Menu ---');
    print('1. Adicionar aluno');
    print('2. Listar alunos');
    print('3. Sair');
    stdout.write('Escolha uma opção: ');
    final opcao = stdin.readLineSync();

    if (opcao == '1') {
      stdout.write('Digite o nome do aluno: ');
      final nome = stdin.readLineSync() ?? '';
      if (nome.isNotEmpty && nome.length <= 50) {
        final stmt = db.prepare('INSERT INTO TB_ALUNO (nome) VALUES (?)');
        stmt.execute([nome]);
        stmt.dispose();
        print('Aluno adicionado com sucesso!');
      } else {
        print('Nome inválido (deve ter até 50 caracteres).');
      }
    } else if (opcao == '2') {
      final ResultSet result = db.select('SELECT * FROM TB_ALUNO');
      print('\n--- Lista de Alunos ---');
      for (final row in result) {
        print('ID: ${row['id']} | Nome: ${row['nome']}');
      }
    } else if (opcao == '3') {
      print('Encerrando o programa...');
      db.dispose();
      break;
    } else {
      print('Opção inválida. Tente novamente.');
    }
  }
}
