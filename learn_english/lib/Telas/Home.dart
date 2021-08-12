import 'package:flutter/material.dart';
import 'package:learn_english/Telas/Bichos.dart';
import 'package:learn_english/Telas/Numeros.dart';
import 'package:learn_english/Telas/Vogais.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Aprenda inglês"),
          bottom: TabBar(
            indicatorWeight: 4,
            indicatorColor: Colors.white,
            labelStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold
            ),
            tabs: [
              Tab(text: "Bichos",),
              Tab(text: "Números",),
              //Tab(text: "Vogais",),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Bichos(),
            Numeros(),
            //Vogais()
          ],
        ),
      ),
    );
  }
}
