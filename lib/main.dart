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

  _salvar() async {
    //MÉTODO PARA SALVAR DADOS NO BANCO DE DADOS

    Database bd = await _recuperarBancoDados();

    Map<String, dynamic> dadosUsuario = { //Map que usamos para passar os dados
      "nome": "zurich destefanno",
      "idade": 46
    };
    int id = await bd.insert("usuarios",
        dadosUsuario); //Uso o insert para adicionar dados. Sempre que iserimos um novo dado, ele retorna o id gerado
    print(
        "Salvo: $id "); //Vai printar no LogCat o id gerado automaticamente pelo autoincrement
  }

  _listarUsuarios() async { //Método que lista os dados salvos

    Database bd = await _recuperarBancoDados();

    //Usamos o Select para selecionar, o * significa todas as colulnas da tabela, poderiamos colocar por exemplo SELECT nome, idade FROM para selecionar somente o nome e idade
    //O FROM usuarios identifica de qual tabela vamos buscar os dados. Podemos aplicar filtros como nos exemplos abaixo

    String sql = "SELECT * FROM usuarios ";
    //String sql = "SELECT * FROM usuarios WHERE nome = 'Jamilton Damasceno'";
    //String sql = "SELECT * FROM usuarios WHERE idade >= 30 AND idade <= 58";
    //String sql = "SELECT * FROM usuarios WHERE idade BETWEEN 18 AND 46 ";  //BETWEEN significa entre
    //String sql = "SELECT * FROM usuarios WHERE idade IN (18,30) ";  //O IN significa onde a idade é 18 e 30

    //String filtro = "an";  //Variável que receberia um valor digitado pelo usuário e usamos ele logo abaixo
    //String sql = "SELECT * FROM usuarios WHERE nome LIKE '%" + filtro + "%' "; //Usando o like e o % não preciso digitar o nome completo,
    // poderiamos recuperar o filtro de um TextField por exmplo, por isso criamos a variável filtro logo acima

    //String sql = "SELECT *, UPPER(nome) as nomeMaiu FROM usuarios WHERE 1=1 ORDER BY UPPER(nome) ASC "; //ASC, DESC
    //Para ordenar por ordem alfabética, temos que ter um where antes do order, caso não tenha, colocamos where 1=1, e usamos o ORDER BY ASC ou DESC
    //Só que como alguns nomes estão maiúsculos, outros minusculos, precisamos usar o UPPER(nome) para orenar como se fossem todos maiúsculos ou então
    //O 'UPPER(nome) as nomeMaiu' antes do FROM para converter realmente em maiúsculos. Nesse caso teíamos que trocar no for de nome para nomeMaiu

   // String sql = "SELECT *, UPPER(nome) as nomeMaiu FROM usuarios WHERE 1=1 ORDER BY idade DESC LIMIT 3"; //ASC, DESC  //O limite limita quantos dados vamos recuperar

    List usuarios = await bd.rawQuery(sql);  // Criamos uma list para armazenar os dados. Essa lista recebe eles através do rawQuery

    for (var usuario in usuarios) {  //Usamos o for para percorrer a nossa lista de usuarios que são maps
      print(
          "item id: " + usuario['id'].toString() +
              " nome: " + usuario['nome'] +
              " idade: " + usuario['idade'].toString()
      );
    }
  }

    @override
    Widget build(BuildContext context) {
      // _salvar();
      _listarUsuarios();

      return Container();
    }

}