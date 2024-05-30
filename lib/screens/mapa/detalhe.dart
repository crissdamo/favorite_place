import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:favorite_places/models/lugar.dart';

class MapaScreen extends StatefulWidget {
  const MapaScreen({
    super.key,
    this.localizacao = const Localizacao(
      longitude: -122.084,
      latitude: 37.422,
      endereco: '',
    ),
    this.selecionado = true,
  });

  final Localizacao localizacao;

  final selecionado;

  @override
  State<MapaScreen> createState() {
    return _MapaScreenState();
  }
}

class _MapaScreenState extends State<MapaScreen> {
  LatLng? _pegarPosicao;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.selecionado ? 'Selecione uma localização' : 'Sua localização',
          style: const TextStyle(
            fontSize: 24,
            color: Color.fromARGB(255, 9, 255, 0),
          ),
        ),
        actions: [
          if (widget.selecionado)
            IconButton(
              icon: const Icon(
                Icons.add_location_alt_sharp,
                size: 30,
                color: Color.fromARGB(255, 9, 255, 0),
              ),
              onPressed: () {
                Navigator.of(context).pop(_pegarPosicao);
              },
            ),
        ],
      ),
      body: GoogleMap(
        // widget.selecionado == false ? null  -> evita que modifique o local depos de já ter sido selecionada e salva
        onTap: widget.selecionado == false
            ? null
            : (posicao) {
                setState(() {
                  _pegarPosicao = posicao;
                });
              },
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.localizacao.latitude,
            widget.localizacao.longitude,
          ),
          zoom: 16,
        ),
        markers: (_pegarPosicao == null && widget.selecionado == true)
            ? {}
            : {
                Marker(
                  markerId: const MarkerId('m1'),
                  position: _pegarPosicao != null
                      ? _pegarPosicao!
                      : LatLng(
                          widget.localizacao.latitude,
                          widget.localizacao.longitude,
                        ),
                )
              },
      ),
    );
  }
}
