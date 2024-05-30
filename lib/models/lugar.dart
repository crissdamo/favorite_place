import 'dart:io';
import 'package:uuid/uuid.dart';

// Cria um identificador únco para cada registro
const uuid = Uuid();

class Localizacao {
  final double latitude;
  final double longitude;
  final String endereco;

  const Localizacao({
    required this.latitude,
    required this.longitude,
    required this.endereco,
  });
}

class Lugar {
  // o identificador será gerado automaticamente
  Lugar({
    required this.titulo,
    required this.imagem,
    required this.localizacao,
  }) : id = uuid.v4();

  final String id;
  final String titulo;
  final File imagem;
  final Localizacao localizacao;
}
