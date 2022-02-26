import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:olx_clone/views/Anuncios.dart';
import 'package:olx_clone/views/DetalhesAnuncio.dart';
import 'package:olx_clone/views/Login.dart';
import 'package:olx_clone/views/MeusAnuncios.dart';
import 'package:olx_clone/views/NovoAnuncio.dart';

import 'models/Anuncio.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute (RouteSettings settings){
    final args = settings.arguments;
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(
          builder: (_) => Anuncios()
        );
      case "/login":
        return MaterialPageRoute(
            builder: (_) => Login()
        );
      case "/meus-anuncios":
        return MaterialPageRoute(
            builder: (_) => MeusAnuncios()
        );
      case "/novo-anuncio":
        return MaterialPageRoute(
            builder: (_) => NovoAnuncio()
        );
      case "/detalhes-anuncio":
        return MaterialPageRoute(
            builder: (_) => DetalhesAnuncio(anuncio: settings.arguments as Anuncio)
        );
      default:
        _erroRota();
        break;
    }
    return _erroRota();
  }

  static Route <dynamic> _erroRota(){
    return MaterialPageRoute(
      builder: (_){
        return Scaffold(
          appBar: AppBar(
            title: Text("Tela não encontrada!"),
          ),
          body: Center(
            child: Text("Tela não encontrada!"),
          ),
        );
      }
    );
  }
}