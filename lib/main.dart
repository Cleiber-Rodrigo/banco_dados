import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main(){
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  _recuperarBancoDados() async {
    final caminhoBancoDados = await getDatabasesPath(); //Temos o caminho do banco de dados
    final localBancoDados = join(caminhoBancoDados, "banco.db");  //Temos o caminho + o nome que vms dar à esse banco de dados
    //Criando o bando de dados
    var retorno = await openDatabase(
      localBancoDados,  //Temos o caminho
      version: 1,  //Vamos atualizando a versão de acordo que vamos atualizando a versão do nosso app
      onCreate: (db, dbVersaoRecente){ //No onCreate passamos uma função anônima com 2 parâmetros: os dados e a última versão
        //Criar uma tabela com o nome usuarios, a primeira coluna será a chave primária e vai incrementar automaticamente o numero na medida
        //que vamos adicionando itens à nossa tabela. o nome será strings e a idade inteiros
      String sql = "CREATE TABLE usuarios (id INTEGER PRIMARY KEY AUTOINCREMENTE, nome VARCHAR, idade INTEGER) ";
      db.execute(sql);
      }
    );
    print("aberto: "+retorno.isOpen.toString()); //Quando colocamos .isOpen , podemos verificar se a tabela está criada, ou seja, aberta ou não
  }
  @override
  Widget build(BuildContext context) {
    _recuperarBancoDados();
    return Container();
  }
}
