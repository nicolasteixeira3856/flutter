import 'package:flutter/material.dart';

class BotaoCustomizado extends StatelessWidget {
  const BotaoCustomizado({
    Key? key,
    required this.texto,
    required this.onPressed,
    this.corTexto = Colors.white,
  }) : super(key: key);

  final String texto;
  final Color corTexto;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: this.onPressed,
      child: Text(
        this.texto,
        style: TextStyle(color: this.corTexto, fontSize: 20),
      ),
      style: ElevatedButton.styleFrom(
          primary: Color(0xFF9C27B0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6)
          ),
          padding: EdgeInsets.fromLTRB(32, 16, 32, 16)),
    );
  }
}
