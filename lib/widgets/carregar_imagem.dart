import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CarregaImagem extends StatefulWidget {
  const CarregaImagem({super.key, required this.quandoCarregarImagem});

  final void Function(File imagem) quandoCarregarImagem;

  @override
  State<StatefulWidget> createState() {
    return _CarregaImagemState();
  }
}

class _CarregaImagemState extends State<CarregaImagem> {
  // inicialmente não terá um arquivo, por isso é preciso colocar o ponto de interrogação
  File? _imagemSelecionada;

  void _carregaImagem() async {
    final imagem = ImagePicker();

    final imagemCarregada =
        await imagem.pickImage(source: ImageSource.camera, maxWidth: 600);

    if (imagemCarregada == null) {
      return;
    }

    setState(() {
      _imagemSelecionada = File(imagemCarregada.path);
    });

    widget.quandoCarregarImagem(_imagemSelecionada!);
  }

  @override
  Widget build(BuildContext context) {
    Widget conteudo = TextButton.icon(
      onPressed: _carregaImagem,
      icon: const Icon(Icons.camera),
      label: const Text("Carregue uma imagem", style: TextStyle(fontSize: 18)),
    );

    if (_imagemSelecionada != null) {
      conteudo = GestureDetector(
        // fica escutando para ver se uma imagem é carregada
        onTap: _carregaImagem,
        child: Image.file(
          // Como está sendo verificando que a imagem não é nula, é possível adicionar o pornto de exclamação
          _imagemSelecionada!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }

    return Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          ),
        ),
        height: 250,
        width: double.infinity,
        alignment: Alignment.center,
        child: conteudo);
  }
}
