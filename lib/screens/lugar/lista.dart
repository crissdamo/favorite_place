import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:favorite_places/screens/lugar/form.dart';
import 'package:favorite_places/widgets/lugares_lista.dart';
import 'package:favorite_places/providers/locais_usuario.dart';

class LugaresScreen extends ConsumerWidget {
  const LugaresScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lugaresUsuario = ref.watch(lugaresUsuarioProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Meus Lugares',
          style: TextStyle(
            fontSize: 24,
            color: Color.fromARGB(255, 9, 255, 0),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),

        // Lista de lugares salvo
        child: LugaresLista(
          lugares: lugaresUsuario,
        ),
      ),

      // botão que leva para o formulário
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(
                Icons.add_location,
                size: 45,
                color: Color.fromARGB(255, 9, 255, 0),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AdicionarLugarScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
