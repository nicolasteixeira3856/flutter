import 'package:flutter/material.dart';
import 'package:olx_clone/views/widgets/BotaoCustomizado.dart';
import 'package:olx_clone/views/widgets/InputCustomizado.dart';
import 'package:olx_clone/models/Usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _controllerEmail =
      TextEditingController(text: "nicolasteixeira@outlook.com");
  TextEditingController _controllerSenha =
      TextEditingController(text: "12345678");

  bool _cadastrar = false;
  String _textoBotao = "Entrar";
  String _mensagemErro = "";

  _cadastrarUsuario(Usuario usuario){
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.createUserWithEmailAndPassword(
        email: usuario.email, password: usuario.senha
    ).then((firebaseUser) {
      Navigator.pushNamedAndRemoveUntil(context, "/", (_) => false);
    });
  }

  _logarUsuario(Usuario usuario){
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signInWithEmailAndPassword(
        email: usuario.email,
        password: usuario.senha
    ).then((firebaseUser){
      Navigator.pushNamedAndRemoveUntil(context, "/", (_) => false);
    });
  }

  _validarCampos() {
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if (email.isNotEmpty && email.contains("@")) {
      if (senha.isNotEmpty && senha.length > 6) {
        //Configurar usuario
        Usuario usuario = Usuario();
        usuario.email = email;
        usuario.senha = senha;
        //Cadastrar ou logar
        if(_cadastrar) {
          //cadastrar
          _cadastrarUsuario(usuario);
        } else {
          //logar
          _logarUsuario(usuario);
        }
      } else {
        setState(() {
          _mensagemErro = "Preencha a senha! Digite mais de 6 caracteres";
        });
      }
    } else {
      setState(() {
        _mensagemErro = "Preecha com um e-mail válido";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 32),
                  child: Image.asset(
                    "images/logo.png",
                    width: 200,
                    height: 150,
                  ),
                ),
                InputCustomizado(
                  controller: _controllerEmail,
                  hint: "E-mail",
                  obscure: false,
                  autofocus: false,
                  type: TextInputType.emailAddress,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: InputCustomizado(
                    controller: _controllerSenha,
                    hint: "Senha",
                    obscure: true,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Logar"),
                    Switch(
                      value: _cadastrar,
                      onChanged: (bool valor) {
                        setState(() {
                          _cadastrar = valor;
                          _textoBotao = "Entrar";
                          if (valor) {
                            _textoBotao = "Cadastrar";
                          }
                        });
                      },
                    ),
                    Text("Cadastrar"),
                  ],
                ),
                BotaoCustomizado(texto: _textoBotao, onPressed: _validarCampos),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    _mensagemErro,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
