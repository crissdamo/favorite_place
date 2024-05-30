import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:favorite_places/widgets/carrega_localizacao.dart';
import 'package:favorite_places/widgets/carregar_imagem.dart';
import 'package:favorite_places/providers/locais_usuario.dart';
import 'package:favorite_places/models/lugar.dart';

class AdicionarLugarScreen extends ConsumerStatefulWidget {
  const AdicionarLugarScreen({super.key});

  @override
  ConsumerState<AdicionarLugarScreen> createState() {
    return _AdicionarLugarScreenState();
  }
}

class _AdicionarLugarScreenState extends ConsumerState<AdicionarLugarScreen> {
  final _tituloController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // Ponto de interrogação serve para indicar que pode iniciar vazio
  File? _imagemSelecionada;
  Localizacao? _localizacaoSelecionada;

  void _savePlace() {
    final tituloInformado = _tituloController.text;

    if (tituloInformado.isEmpty ||
        _imagemSelecionada == null ||
        _localizacaoSelecionada == null) {
      // TODO: notificar usuário quando descrição não informada
      // showDialog(context: context, builder: builder)
      return;
    }

    // pega titulo informada e salva um novo lugar
    ref.read(lugaresUsuarioProvider.notifier).adicionaLugar(
        tituloInformado, _imagemSelecionada!, _localizacaoSelecionada!);

    // sai da tela depois que um novo registro é salvo
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _tituloController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Adiciona novo Lugar',
          style: TextStyle(
            fontSize: 24,
            color: Color.fromARGB(255, 9, 255, 0),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Campo de título do lugar
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  labelStyle: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 9, 255, 0),
                  ),
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o nome do lugar.';
                  }
                  return null;
                },
              ),

              // carrega imagem
              const SizedBox(height: 10),
              CarregaImagem(
                quandoCarregarImagem: (imagem) {
                  _imagemSelecionada = imagem;
                },
              ),
              const SizedBox(height: 10),
              CarregaLocalizacao(
                quandoSelecionaLocalizacao: (localizacao) {
                  _localizacaoSelecionada = localizacao;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _savePlace,
                icon: const Icon(Icons.add),
                label: const Text('Adiciona Lugar',
                    style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
