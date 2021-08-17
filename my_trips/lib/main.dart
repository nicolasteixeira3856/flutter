import 'package:flutter/material.dart';
import 'package:my_trips/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await firebase_core.Firebase.initializeApp();
  runApp(MaterialApp(
    home: SplashScreen(),
    debugShowCheckedModeBanner: false,
  ));
}