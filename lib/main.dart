import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() => runApp(
    MaterialApp(
      home: Home(),
    )
);

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  _recuperarBancoDados() async {

    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados = join(caminhoBancoDados, "banco.db");

    Database bd = await openDatabase(
        localBancoDados,
        version: 1,
        onCreate: (Database db, int version) async {
          String sql = "CREATE TABLE usuarios (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, nome VARCHAR(200) NOT NULL, idade INTEGER NOT NULL) ";
          await db.execute(sql);
        }
    );

    return bd;
    //print("aberto: " + bd.isOpen.toString() );

  }

  _salvar() async {  //MÉTODO PARA SALVAR DADOS NO BANCO DE DADOS

    Database bd = await _recuperarBancoDados();

    Map<String, dynamic> dadosUsuario = {  //Map que usamos para passar os dados
      "nome" : "Maria Silva",
      "idade" : 58
    };
    int id = await bd.insert("usuarios", dadosUsuario);  //Uso o insert para adicionar dados. Sempre que iserimos um novo dado, ele retorna o id gerado
    print("Salvo: $id " );  //Vai printar no LogCat o id gerado automaticamente pelo autoincrement

  }

  @override
  Widget build(BuildContext context) {

    _salvar();

    return Container();
  }
}

