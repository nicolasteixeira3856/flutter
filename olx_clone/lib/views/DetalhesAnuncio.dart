import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:olx_clone/main.dart';
import 'package:olx_clone/models/Anuncio.dart';
import 'package:url_launcher/url_launcher.dart';


class DetalhesAnuncio extends StatefulWidget {
  const DetalhesAnuncio({Key? key,  required this.anuncio}) : super(key: key);

  final Anuncio anuncio;

  @override
  _DetalhesAnuncioState createState() => _DetalhesAnuncioState();
}

class _DetalhesAnuncioState extends State<DetalhesAnuncio> {

  late Anuncio _anuncio;


  List<String> _listaUrlImagens(){
    print(_anuncio.fotos);
    return _anuncio.fotos;
  }

  _ligarTelefone(String telefone) async {

    if( await canLaunch("tel:$telefone") ){
      await launch("tel:$telefone");
    }else{
      print("Não pode fazer a ligação");
    }

  }

  @override
  void initState() {
    super.initState();
    _anuncio = widget.anuncio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Anuncio"),
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              SizedBox(
                height: 250,
                child: CarouselSlider(
                  options: CarouselOptions(
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                    autoPlay: false,
                  ),
                  items: _listaUrlImagens().map((item) => Container(
                    height: 250,
                    child: Center(
                      child: Image.network(item, fit: BoxFit.cover, width: 1000,)),
                    )
                  ).toList(),
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    Text(
                      "R\$ ${_anuncio.preco}",
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: temaPadrao.primaryColor
                      ),
                    ),

                    Text(
                      "${_anuncio.titulo}",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w400
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(),
                    ),

                    Text(
                      "Descrição",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      ),
                    ),

                    Text(
                      "${_anuncio.descricao}",
                      style: TextStyle(
                          fontSize: 18
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(),
                    ),

                    Text(
                      "Contato",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(bottom: 66),
                      child: Text(
                        "${_anuncio.telefone}",
                        style: TextStyle(
                            fontSize: 18
                        ),
                      ),
                    ),


                  ],),
              )
            ],
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: GestureDetector(
              child: Container(
                child: Text(
                  "Ligar",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20
                  ),
                ),
                padding: EdgeInsets.all(16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: temaPadrao.primaryColor,
                    borderRadius: BorderRadius.circular(30)
                ),
              ),
              onTap: (){
                _ligarTelefone( _anuncio.telefone );
              },
            ),
          )
        ],
      ),
    );
  }
}
