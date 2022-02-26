import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:olx_clone/models/Anuncio.dart';
import 'package:olx_clone/util/Configuracoes.dart';
import 'package:olx_clone/views/widgets/ItemAnuncio.dart';

class Anuncios extends StatefulWidget {
  const Anuncios({Key? key}) : super(key: key);

  @override
  _AnunciosState createState() => _AnunciosState();
}

class _AnunciosState extends State<Anuncios> {
  final _controller = StreamController<QuerySnapshot>.broadcast();

  List<String> itensMenu = [];

  String _itemSelecionadoEstado = "";
  String _itemSelecionadoCategoria = "";

  List<DropdownMenuItem<String>> _listaItensDropEstados = [];
  List<DropdownMenuItem<String>> _listaItensDropCategorias = [];

  _escolhaMenuItem(String itemEscolhido) {
    switch (itemEscolhido) {
      case "Meus anúncios":
        Navigator.pushNamed(context, "/meus-anuncios");
        break;
      case "Entrar / Cadastrar":
        Navigator.pushNamed(context, "/login");
        break;
      case "Deslogar":
        _deslogarUsuario();
        break;
    }
  }

  _deslogarUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    Navigator.pushNamedAndRemoveUntil(context, "/", (_) => false);
  }

  Future _verificarUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = auth.currentUser;

    if (usuarioLogado == null) {
      itensMenu = ["Entrar / Cadastrar"];
    } else {
      itensMenu = ["Meus anúncios", "Deslogar"];
    }
  }

  _carregarItensDropdown() {
    _listaItensDropCategorias = Configuracoes.getCategorias();
    _listaItensDropEstados = Configuracoes.getEstados();
  }

  Future<Stream<QuerySnapshot>?> _adicionarListenerAnuncios() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    Stream<QuerySnapshot> stream = db
        .collection("anuncios")
        .snapshots();

    stream.listen((event) {
      _controller.add(event);
    });
  }

  Future<Stream<QuerySnapshot>?> _filtrarAnuncios() async {

    FirebaseFirestore db = FirebaseFirestore.instance;

    print("Estado: " + _itemSelecionadoEstado != "null" && _itemSelecionadoEstado != "");
    print("Estado: " + _itemSelecionadoEstado);
    print("Categoria: " + _itemSelecionadoCategoria);

    Query query = db.collection("anuncios");

    if (_itemSelecionadoEstado != "null") {
      if (_itemSelecionadoEstado != "") {
        query = query.where("estado", isEqualTo: _itemSelecionadoEstado);
      }
    }

    if (_itemSelecionadoCategoria != "null") {
      if (_itemSelecionadoCategoria != "") {
        query = query.where("categoria", isEqualTo: _itemSelecionadoCategoria);
      }
    }

    Stream<QuerySnapshot> stream = query.snapshots();

    stream.listen((event) {
      _controller.add(event);
    });
  }

  @override
  void initState() {
    super.initState();
    _carregarItensDropdown();
    _verificarUsuarioLogado();

    _adicionarListenerAnuncios();
  }

  @override
  Widget build(BuildContext context) {
    var carregandoDados = Center(
      child: Column(
        children: [Text("Carregando anúncios"), CircularProgressIndicator()],
      ),
    );

    return Scaffold(
        appBar: AppBar(
          title: Text("OLX"),
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            PopupMenuButton<String>(
              onSelected: _escolhaMenuItem,
              itemBuilder: (context) {
                return itensMenu.map((String item) {
                  return PopupMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList();
              },
            )
          ],
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: DropdownButtonFormField(
                          hint: Text("Estados"),
                          style: TextStyle(color: Colors.black, fontSize: 20),
                          items: _listaItensDropEstados,
                          onChanged: (valor) {
                            setState(() {
                              _itemSelecionadoEstado = valor.toString();
                              _filtrarAnuncios();
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: DropdownButtonFormField(
                          hint: Text("Categorias"),
                          style: TextStyle(color: Colors.black, fontSize: 20),
                          items: _listaItensDropCategorias,
                          onChanged: (valor) {
                            setState(() {
                              _itemSelecionadoCategoria = valor.toString();
                              _filtrarAnuncios();
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                StreamBuilder(
                  stream: _controller.stream,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return carregandoDados;
                      case ConnectionState.active:
                      case ConnectionState.done:
                        if (snapshot.hasError)
                          return Text("Erro ao carregar os dados");
                        QuerySnapshot querySnapshot =
                            snapshot.data as QuerySnapshot;
                        if (querySnapshot.docs.length == 0) {
                          return Container(
                            padding: EdgeInsets.all(25),
                            child: Text(
                              "Nenhum anúncio! :( ",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          );
                        }
                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: querySnapshot.docs.length,
                          itemBuilder: (_, index) {
                            List<DocumentSnapshot> anuncios = querySnapshot.docs.toList();
                            DocumentSnapshot documentSnapshot = anuncios[index];
                            Anuncio anuncio = Anuncio.fromDocumentSnapshot(documentSnapshot);

                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  "/detalhes-anuncio",
                                  arguments: anuncio
                                );
                              },
                              child: Card(
                                child: Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 120,
                                        height: 120,
                                        child: Image.network(
                                          anuncio.fotos[0],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 8),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                anuncio.titulo,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              Text("R\$ ${anuncio.preco}")
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                    }
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
