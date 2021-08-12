import 'package:flutter/material.dart';
import 'package:learn_english/Telas/Home.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      primaryColor: Color(0xFF795548),
      scaffoldBackgroundColor: Color(0xFFF5E9B9)
    ),
  ));
}