import 'package:flutter/material.dart';
import 'package:olx_clone/models/Anuncio.dart';

class ItemAnuncio extends StatelessWidget {
  const ItemAnuncio({
    Key? key,
    required this.anuncio,
  }) : super(key: key);

  final Anuncio anuncio;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: Image.network(
                  anuncio.fotos[0],
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        anuncio.titulo,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Text("R\$ ${anuncio.preco}")
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
