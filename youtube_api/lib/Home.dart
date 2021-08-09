import 'package:flutter/material.dart';
import 'package:youtube_api/CustomSearchDelegate.dart';
import 'package:youtube_api/telas/Biblioteca.dart';
import 'package:youtube_api/telas/EmAlta.dart';
import 'package:youtube_api/telas/Inicio.dart';
import 'package:youtube_api/telas/Inscricao.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _indiceAtual = 0;
  String _resultado = "";

  @override
  Widget build(BuildContext context) {
    List<Widget> telas = [
      Inicio(
        pesquisa: _resultado,
      ),
      EmAlta(),
      Inscricao(),
      Biblioteca()
    ];

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey),
        backgroundColor: Colors.white,
        title: Image.asset(
          "images/youtube.png",
          width: 98,
          height: 22,
        ),
        actions: [
          /*IconButton(onPressed: () {}, icon: Icon(Icons.videocam_sharp)),
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: Icon(Icons.account_circle)),*/
          IconButton(
              onPressed: () async {
                String res = await showSearch(
                    context: context,
                    delegate: CustomSearchDelegate()) as String;
                setState(() {
                  _resultado = res;
                });
              },
              icon: Icon(Icons.search)),
        ],
      ),
      body: Container(padding: EdgeInsets.all(16), child: telas[_indiceAtual]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceAtual,
        onTap: (indice) {
          setState(() {
            _indiceAtual = indice;
          });
        },
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.red,
        items: [
          BottomNavigationBarItem(
            label: "Inicio",
            icon: Icon(Icons.home),
            //backgroundColor: Colors.orange
          ),
          BottomNavigationBarItem(
            label: "Em alta",
            icon: Icon(Icons.whatshot),
            //backgroundColor: Colors.red
          ),
          BottomNavigationBarItem(
            label: "Inscrições",
            icon: Icon(Icons.subscriptions),
            //backgroundColor: Colors.blue
          ),
          BottomNavigationBarItem(
            label: "Biblioteca",
            icon: Icon(Icons.folder),
            //backgroundColor: Colors.green
          )
        ],
      ),
    );
  }
}
