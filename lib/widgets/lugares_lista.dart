import 'package:favorite_places/screens/lugar/detalhe.dart';
import 'package:flutter/material.dart';

import 'package:favorite_places/models/lugar.dart';

class LugaresLista extends StatelessWidget {
  const LugaresLista({super.key, required this.lugares});

  final List<Lugar> lugares;

  @override
  Widget build(BuildContext context) {
    if (lugares.isEmpty) {
      return Center(
        child: Text(
          'Nenhum lugar encontrado',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Theme.of(context).colorScheme.onSecondary, fontSize: 24),
        ),
      );
    }

    // ListView: cria scroll se lista ficar maior que a tela
    return ListView.builder(
      itemCount: lugares.length,
      itemBuilder: (context, index) => ListTile(
        // transforma a imagem em circulo
        leading: CircleAvatar(
          radius: 26,
          backgroundImage: FileImage(lugares[index].imagem),
        ),
        title: Text(
          lugares[index].titulo,
          // copyWith: sobrepõe estilos
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.onBackground, fontSize: 22),
        ),
        subtitle: Text(
          lugares[index].localizacao.endereco,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Theme.of(context).colorScheme.onBackground, fontSize: 18),
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DetalheLugarScreen(lugar: lugares[index]),
            ),
          );
        },
      ),
    );
  }
}
