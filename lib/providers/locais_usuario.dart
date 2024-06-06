import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:favorite_places/models/lugar.dart'; // gerenciamento de cache

// Gerenciamento dos locais selecionados pelo usuário
class NotificadorLugarUsuario extends StateNotifier<List<Lugar>> {
  NotificadorLugarUsuario() : super(const []);

  void adicionaLugar(String titulo, File imagem, Localizacao localizacao) {
    final novoLugar = Lugar(
      titulo: titulo,
      imagem: imagem,
      localizacao: localizacao,
    );
    state = [novoLugar, ...state];
  }
}

final lugaresUsuarioProvider =
    StateNotifierProvider<NotificadorLugarUsuario, List<Lugar>>(
  (ref) => NotificadorLugarUsuario(),
);
