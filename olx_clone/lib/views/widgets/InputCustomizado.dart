import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputCustomizado extends StatelessWidget {
  const InputCustomizado({
    Key? key,
    required this.controller,
    required this.hint,
    this.obscure = false,
    this.autofocus = false,
    this.type = TextInputType.text,
  }) : super(key: key);

  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final bool autofocus;
  final TextInputType type;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: this.controller,
      autofocus: this.autofocus,
      obscureText: this.obscure,
      keyboardType: this.type,
      style: TextStyle(fontSize: 20),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
          hintText: this.hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6)
          )
      ),
    );
  }
}
