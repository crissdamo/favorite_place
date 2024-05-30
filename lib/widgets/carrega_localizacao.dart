import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

import 'package:favorite_places/models/lugar.dart';
import 'package:favorite_places/screens/mapa/detalhe.dart';

class CarregaLocalizacao extends StatefulWidget {
  const CarregaLocalizacao(
      {super.key, required this.quandoSelecionaLocalizacao});

  final void Function(Localizacao localizacao) quandoSelecionaLocalizacao;

  @override
  State<CarregaLocalizacao> createState() {
    return _CarregaLocalizacaoState();
  }
}

class _CarregaLocalizacaoState extends State<CarregaLocalizacao> {
  Localizacao? _capturaLocalizacao;
  var _localizacaoCapturada = false;

  String get localizacaoImagem {
    if (_capturaLocalizacao == null) {
      return '';
    }
    final latitude = _capturaLocalizacao!.latitude;
    final longitude = _capturaLocalizacao!.longitude;
    var apiKey = dotenv.env['API_GOOOGLE_KEY'];
    var host = dotenv.env['HOST_GOOOGLE_MAP_API'];

    return '$host/staticmap?center=$latitude,$longitude&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$latitude,$longitude&key=$apiKey';
  }

  Future<void> _salvarLugar(double latitude, double longitude) async {
    var apiKey = dotenv.env['API_GOOOGLE_KEY'];
    var host = dotenv.env['HOST_GOOOGLE_MAP_API'];

    final url =
        Uri.parse("$host/geocode/json?latlng=$latitude,$longitude&key=$apiKey");
    final resposta = await http.get(url);
    final dadosResposta = json.decode(resposta.body);
    final endereco = dadosResposta['results'][0]['formatted_address'];

    setState(() {
      _capturaLocalizacao = Localizacao(
        latitude: latitude,
        longitude: longitude,
        endereco: endereco,
      );
      _localizacaoCapturada = false;
    });

    widget.quandoSelecionaLocalizacao(_capturaLocalizacao!);
  }

  // Pegar localização do celular
  void _pegaLocalizacao() async {
    // código da biblioteca location: https://pub.dev/packages/location
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    // Pegar permissão e guarda opção do usuário para não solicitar novamente
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _localizacaoCapturada = true;
    });

    locationData = await location.getLocation();
    final latitude = locationData.latitude;
    final longitude = locationData.longitude;

    if (latitude == null || longitude == null) {
      //TODO: adicionar
      return;
    }

    _salvarLugar(latitude, longitude);
  }

  // Seleciona um lugar pelo mapa
  void _selecionNoMapa() async {
    final pegarLocalizacao = await Navigator.of(context).push<LatLng>(
      // Informar qual dado pretende receber: <LatLng>
      MaterialPageRoute(
        builder: (context) => const MapaScreen(),
      ),
    );

    if (pegarLocalizacao == null) {
      return;
    }

    _salvarLugar(pegarLocalizacao.latitude, pegarLocalizacao.longitude);
  }

  @override
  Widget build(BuildContext context) {
    Widget previasConteudo = Text(
      'Nenhuma localização escolhida',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onSecondary,
            fontSize: 18,
          ),
    );

    if (_capturaLocalizacao != null) {
      previasConteudo = Image.network(
        localizacaoImagem,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    if (_localizacaoCapturada) {
      previasConteudo = const CircularProgressIndicator();
    }
    return Column(
      // adiciona uma quantidade uniforme de espaço
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),
          ),
          child: previasConteudo,
        ),
        Row(
          children: [
            TextButton.icon(
              onPressed: _pegaLocalizacao,
              icon: const Icon(
                Icons.location_on,
                size: 26,
              ),
              label: const Text('Localização atual',
                  style: TextStyle(fontSize: 16)),
            ),
            TextButton.icon(
              onPressed: _selecionNoMapa,
              icon: const Icon(
                Icons.map_sharp,
                size: 26,
              ),
              label: const Text(
                'Selecionar no mapa',
                style: TextStyle(fontSize: 16),
              ),
            )
          ],
        )
      ],
    );
  }
}
