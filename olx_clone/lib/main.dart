import 'package:flutter/material.dart';
import 'package:olx_clone/RouteGenerator.dart';
import 'package:olx_clone/views/Anuncios.dart';
import 'package:olx_clone/views/Login.dart';
import 'package:firebase_core/firebase_core.dart';

final ThemeData temaPadrao = ThemeData(
    primaryColor: Color(0xFF9C27B0),
    accentColor: Color(0xFF7B1FA2),
    inputDecorationTheme: InputDecorationTheme(
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF7B1FA2))),
    )
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    title: "OLX",
    home: Anuncios(),
    debugShowCheckedModeBanner: false,
    theme: temaPadrao,
    initialRoute: "/",
    onGenerateRoute: RouteGenerator.generateRoute,
  ));
}