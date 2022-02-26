import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:olx_clone/models/Anuncio.dart';
import 'package:olx_clone/views/widgets/ItemAnuncio.dart';

class MeusAnuncios extends StatefulWidget {
  const MeusAnuncios({Key? key}) : super(key: key);

  @override
  _MeusAnunciosState createState() => _MeusAnunciosState();
}

class _MeusAnunciosState extends State<MeusAnuncios> {
  final _controller = StreamController<QuerySnapshot>.broadcast();
  late String _idUsuarioLogado;

  _recuperarDadosUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = auth.currentUser;
    _idUsuarioLogado = usuarioLogado!.uid;
  }

  // Future<Stream<QuerySnapshot>> _adicionarListenerAnuncios() async {
  //   await _recuperarDadosUsuarioLogado();
  //
  //   FirebaseFirestore db = FirebaseFirestore.instance;
  //   Stream<QuerySnapshot> stream = db
  //       .collection("meus_anuncios")
  //       .doc(_idUsuarioLogado)
  //       .collection("anuncios")
  //       .snapshots();
  //
  //   stream.listen((event) {
  //     _controller.add(event);
  //   });
  //
  //   return CircularProgressindicator()
  //
  // }

  _removerAnuncio(String idAnuncio) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db
        .collection("meus-anuncios")
        .doc(_idUsuarioLogado)
        .collection("anuncios")
        .doc(idAnuncio)
        .delete()
        .then(((_) {
      db.collection("anuncios").doc(idAnuncio).delete();
    }));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recuperarDadosUsuarioLogado();

    FirebaseFirestore db = FirebaseFirestore.instance;
    Stream<QuerySnapshot> stream = db
        .collection("meus-anuncios")
        .doc(_idUsuarioLogado)
        .collection("anuncios")
        .snapshots();

    stream.listen((event) {
      _controller.add(event);
    });
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
          title: Text("Meus Anúncios"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, "/novo-anuncio");
          },
          foregroundColor: Colors.white,
          child: Icon(Icons.add),
        ),
        body: StreamBuilder(
          stream: _controller.stream,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return carregandoDados;
              case ConnectionState.active:
              case ConnectionState.done:
                if (snapshot.hasError) return Text("Erro ao carregar os dados");
                QuerySnapshot querySnapshot = snapshot.data as QuerySnapshot;
                return ListView.builder(
                  itemCount: querySnapshot.docs.length,
                  itemBuilder: (_, index) {
                    List<DocumentSnapshot> anuncios =
                        querySnapshot.docs.toList();
                    DocumentSnapshot documentSnapshot = anuncios[index];
                    Anuncio anuncio =
                        Anuncio.fromDocumentSnapshot(documentSnapshot);
                    return GestureDetector(
                      onTap: () {},
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
                                flex: 3,
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
                              Expanded(
                                flex: 1,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.red,
                                      padding: EdgeInsets.all(10)),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text("Confirmar"),
                                            content: Text(
                                                "Digita realmente excluir o anúncio?"),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    primary: Colors.grey[500]),
                                                child: Text(
                                                  "Cancelar",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  _removerAnuncio(anuncio.id);
                                                  Navigator.of(context).pop();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    primary: Colors.red),
                                                child: Text(
                                                  "Remover",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
            }
          },
        ));
  }
}
