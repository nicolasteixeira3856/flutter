import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:olx_clone/models/Anuncio.dart';
import 'package:olx_clone/util/Configuracoes.dart';
import 'package:olx_clone/views/widgets/BotaoCustomizado.dart';
import 'package:image_picker/image_picker.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:olx_clone/views/widgets/InputCustomizado.dart';
import 'package:validadores/validadores.dart';

class NovoAnuncio extends StatefulWidget {
  const NovoAnuncio({Key? key}) : super(key: key);

  @override
  _NovoAnuncioState createState() => _NovoAnuncioState();
}

class _NovoAnuncioState extends State<NovoAnuncio> {
  List<File> _listaImagens = [];
  List<DropdownMenuItem<String>> _listaItensDropEstados = [];
  List<DropdownMenuItem<String>> _listaItensDropCategorias = [];
  final _formKey = GlobalKey<FormState>();

  late String _itemSelecionadoEstado;

  late String _itemSelecionadoCategoria;

  TextEditingController _tituloController = TextEditingController();
  TextEditingController _precoController = TextEditingController();
  TextEditingController _telefoneController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();

  late Anuncio _anuncio;

  late BuildContext _dialogContext;

  _selecionarImagemGaleria() async {
    try {
      PickedFile? pickedFile =
          await ImagePicker().getImage(source: ImageSource.gallery);
      File imagemSelecionada = File(pickedFile!.path);
      setState(() {
        _listaImagens.add(imagemSelecionada);
      });
    } catch (error) {
      throw error;
    }
  }

  _abrirDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  height: 20,
                ),
                Text("Salvando anúncio...")
              ],
            ),
          );
        });
  }

  Future _uploadImagens() async {
    String nomeImagem = DateTime.now().millisecondsSinceEpoch.toString();
    for (var imagem in _listaImagens) {
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('meus_anuncios')
          .child(_anuncio.id)
          .child(nomeImagem);
      firebase_storage.UploadTask uploadTask = ref.putFile(imagem);
      firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
      String url = await taskSnapshot.ref.getDownloadURL();
      _anuncio.fotos.add(url);
    }
  }

  _salvarAnuncio() async {
    _abrirDialog(_dialogContext);

    //Upload imagens
    await _uploadImagens();
    //Salvar anuncio
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = auth.currentUser;
    String idUsuarioLogado = usuarioLogado!.uid;
    FirebaseFirestore db = FirebaseFirestore.instance;
    db
        .collection("meus-anuncios")
        .doc(idUsuarioLogado)
        .collection("anuncios")
        .doc(_anuncio.id)
        .set(_anuncio.toMap())
        .then((_) {
      //Salvar anúncio publico
      db
          .collection("anuncios")
          .doc(_anuncio.id)
          .set(_anuncio.toMap())
          .then((_) {
        Navigator.pop(_dialogContext);
        Navigator.pop(context);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _carregarItensDropdown();
    _anuncio = Anuncio.gerarId();
  }

  _carregarItensDropdown() {
    //Categorias
    // _listaItensDropCategorias.add(DropdownMenuItem(
    //   child: Text("Automóvel"),
    //   value: "auto",
    // ));
    //
    // _listaItensDropCategorias.add(DropdownMenuItem(
    //   child: Text("Imóvel"),
    //   value: "imovel",
    // ));
    //
    // _listaItensDropCategorias.add(DropdownMenuItem(
    //   child: Text("Eletrônicos"),
    //   value: "eletro",
    // ));
    //
    // _listaItensDropCategorias.add(DropdownMenuItem(
    //   child: Text("Moda"),
    //   value: "moda",
    // ));
    //
    // _listaItensDropCategorias.add(DropdownMenuItem(
    //   child: Text("Videogame"),
    //   value: "videogame",
    // ));
    //
    // _listaItensDropCategorias.add(DropdownMenuItem(
    //   child: Text("Esportes"),
    //   value: "esportes",
    // ));
    _listaItensDropCategorias = Configuracoes.getCategorias();

    //Estados
    // for (var estado in Estados.listaEstadosSigla) {
    //   _listaItensDropEstados.add(DropdownMenuItem(
    //     child: Text(estado),
    //     value: estado,
    //   ));
    // }
    _listaItensDropEstados = Configuracoes.getEstados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Novo anúncio"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //Area de imagens
                FormField<List>(
                  initialValue: _listaImagens,
                  validator: (imagens) {
                    if (imagens!.length == 0) {
                      return "Necessário selecionar uma imagem!";
                    }
                    return null;
                  },
                  builder: (state) {
                    return Column(
                      children: [
                        Container(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _listaImagens.length + 1,
                            itemBuilder: (context, index) {
                              if (index == _listaImagens.length) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: GestureDetector(
                                    onTap: () {
                                      _selecionarImagemGaleria();
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey[400],
                                      radius: 50,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add_a_photo,
                                            size: 40,
                                            color: Colors.grey[100],
                                          ),
                                          Text(
                                            "Adicionar",
                                            style: TextStyle(
                                                color: Colors.grey[100]),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                              if (_listaImagens.length > 0) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) => Dialog(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8),
                                                      child: Image.file(
                                                        _listaImagens[index],
                                                        width: 200,
                                                        height: 200,
                                                      ),
                                                    ),
                                                    ElevatedButton(
                                                      child: Text(
                                                        "Excluir",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              primary:
                                                                  Colors.red),
                                                      onPressed: () {
                                                        setState(() {
                                                          _listaImagens
                                                              .removeAt(index);
                                                          Navigator.of(context)
                                                              .pop();
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ));
                                    },
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundImage:
                                          FileImage(_listaImagens[index]),
                                      child: Container(
                                        color:
                                            Color.fromRGBO(255, 255, 255, 0.4),
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return Container();
                            },
                          ),
                        ),
                        if (state.hasError)
                          Container(
                            child: Text(
                              "[${state.errorText}]",
                              style: TextStyle(color: Colors.red, fontSize: 14),
                            ),
                          )
                      ],
                    );
                  },
                ),
                //Menus Dropdown
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: DropdownButtonFormField(
                          hint: Text("Estados"),
                          onSaved: (estado) {
                            _anuncio.estado = estado.toString();
                          },
                          style: TextStyle(color: Colors.black, fontSize: 20),
                          items: _listaItensDropEstados,
                          validator: (valor) =>
                              valor == null ? '[Campo obrigatório]' : null,
                          onChanged: (valor) {
                            setState(() {
                              _itemSelecionadoEstado = valor.toString();
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
                          onSaved: (categoria) {
                            _anuncio.categoria = categoria.toString();
                          },
                          style: TextStyle(color: Colors.black, fontSize: 20),
                          items: _listaItensDropCategorias,
                          validator: (valor) =>
                              valor == null ? '[Campo obrigatório]' : null,
                          onChanged: (valor) {
                            setState(() {
                              _itemSelecionadoCategoria = valor.toString();
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                //Caixas de textos e botoes

                Padding(
                  padding: const EdgeInsets.only(bottom: 15, top: 15),
                  child: TextFormField(
                    controller: _tituloController,
                    style: TextStyle(fontSize: 20),
                    onSaved: (titulo) {
                      _anuncio.titulo = titulo.toString();
                    },
                    validator: (valor) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                          .valido(valor.toString());
                    },
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Título",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6))),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextFormField(
                    controller: _precoController,
                    style: TextStyle(fontSize: 20),
                    onSaved: (preco) {
                      _anuncio.preco = preco.toString();
                    },
                    validator: (valor) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                          .valido(valor.toString());
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      RealInputFormatter(centavos: true)
                    ],
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Preço",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6))),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextFormField(
                    controller: _telefoneController,
                    style: TextStyle(fontSize: 20),
                    onSaved: (telefone) {
                      _anuncio.telefone = telefone.toString();
                    },
                    validator: (valor) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                          .valido(valor.toString());
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TelefoneInputFormatter()
                    ],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Telefone",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6))),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextFormField(
                    controller: _descricaoController,
                    style: TextStyle(fontSize: 20),
                    onSaved: (descricao) {
                      _anuncio.descricao = descricao.toString();
                    },
                    validator: (valor) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                          .maxLength(200, msg: "Máximo de 200 caracteres")
                          .valido(valor.toString());
                    },
                    maxLines: null,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Descrição (200 caracteres)",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6))),
                  ),
                ),

                BotaoCustomizado(
                    texto: "Cadastrar anúncio",
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        _dialogContext = context;
                        _salvarAnuncio();
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
