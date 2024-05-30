import 'package:flutter/material.dart';

import 'package:favorite_places/models/lugar.dart';
import 'package:favorite_places/screens/mapa/detalhe.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

class DetalheLugarScreen extends StatelessWidget {
  const DetalheLugarScreen({super.key, required this.lugar});

  final Lugar lugar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          lugar.titulo,
          style: const TextStyle(
            fontSize: 24,
            color: Color.fromARGB(255, 9, 255, 0),
          ),
        ),
      ),
      // stack permite colocar diversos widgets empilhados
      body: Stack(
        children: [
          Image.file(
            lugar.imagem,
            fit: BoxFit.cover,
            width: double.infinity, // máximo possível de espaço
            height: double.infinity, // máximo possível de espaço
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MapaScreen(
                          localizacao: lugar.localizacao,
                          selecionado: false,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    color: Theme.of(context).colorScheme.secondary,
                    child: Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: Text(
                        lugar.localizacao.endereco,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Theme.of(context).colorScheme.background,
                              fontSize: 24,
                            ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
