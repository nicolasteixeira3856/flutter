import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _listaTarefas = [];
  Map<String, dynamic> _ultimaTarefaRemovida = Map();
  TextEditingController _controllerTarefa = TextEditingController();

  Future<File> _getFile() async {
    final diretorio = await getApplicationDocumentsDirectory();
    return File("${diretorio.path}/dados.json");
  }

  _salvarTarefa() {
    String texto = _controllerTarefa.text;
    Map<String, dynamic> tarefa = Map();
    tarefa["titulo"] = texto;
    tarefa["realizada"] = false;
    setState(() {
      _listaTarefas.add(tarefa);
    });
    _salvarArquivo();
    _controllerTarefa.text = "";
  }

  _salvarArquivo() async {
    var arquivo = await _getFile();
    String dados = json.encode(_listaTarefas);
    arquivo.writeAsStringSync(dados);
  }

  _lerArquivo() async {
    try {
      final arquivo = await _getFile();
      return arquivo.readAsString();
    } catch (e) {
      return null;
    }
  }

  Widget criarItemLista(context, index) {
    //final item = _listaTarefas[index]["titulo"];

    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        _ultimaTarefaRemovida = _listaTarefas[index];
        _listaTarefas.removeAt(index);
        _salvarArquivo();
        final snackbar = SnackBar(
          content: Text("Tarefa removida!"),
          duration: Duration(seconds: 6),
          action: SnackBarAction(
            label: "Desfazer",
            onPressed: () {
              setState(() {
                _listaTarefas.insert(index, _ultimaTarefaRemovida);
              });
              _salvarArquivo();
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      },
      background: Container(
        color: Colors.red,
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              Icons.delete,
              color: Colors.white,
            )
          ],
        ),
      ),
      child: CheckboxListTile(
          title: Text(_listaTarefas[index]["titulo"]),
          value: _listaTarefas[index]["realizada"],
          onChanged: (valorAlterado) {
            setState(() {
              _listaTarefas[index]["realizada"] = valorAlterado;
            });
            _salvarArquivo();
          }),
    );
  }

  @override
  void initState() {
    super.initState();

    _lerArquivo().then((dados) {
      setState(() {
        _listaTarefas = json.decode(dados);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //_salvarArquivo();
    print("itens" + _listaTarefas.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de tarefas"),
        backgroundColor: Color(0xFF2550b3),
      ),
      body: ListView.builder(
          itemCount: _listaTarefas.length, itemBuilder: criarItemLista),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Adicionar Tarefa"),
                  content: TextField(
                    controller: _controllerTarefa,
                    decoration: InputDecoration(labelText: "Digite sua tarefa"),
                    onChanged: (text) {},
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Cancelar"),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.redAccent,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        //Salvar
                        _salvarTarefa();
                        Navigator.pop(context);
                      },
                      child: Text("Salvar"),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF2550b3),
                      ),
                    )
                  ],
                );
              });
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF2550b3),
        elevation: 8.0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      /*bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          children: [
            IconButton(onPressed: (){}, icon: Icon(Icons.menu))
          ],
        ),
      ),*/
    );
  }
}
