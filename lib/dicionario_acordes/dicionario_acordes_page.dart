import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'ferramentas/audio_controller.dart';

class DicionarioAcordesPage extends StatefulWidget {
  const DicionarioAcordesPage({super.key});

  @override
  State<DicionarioAcordesPage> createState() => _DicionarioAcordesPageState();
}

class _DicionarioAcordesPageState extends State<DicionarioAcordesPage> {
  final AudioController _audioController = AudioController();
  String _instrumento = 'Violão';
  Map<String, dynamic> _dadosAcordes = {};
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  @override
  void dispose() {
    _audioController.dispose();
    super.dispose();
  }

  Future<void> _carregarDados() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/acordes.json');
      final Map<String, dynamic> dados = json.decode(jsonString);
      setState(() {
        _dadosAcordes = dados;
        _carregando = false;
      });
    } catch (e) {
      debugPrint("Erro ao carregar acordes: $e");
      setState(() => _carregando = false);
    }
  }

  Future<void> _iniciarMicrofone() async {
    var status = await Permission.microphone.request();
    if (status.isGranted) {
      debugPrint("Microfone concedido!");
    } else {
      debugPrint("Permissão de microfone negada.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DICIONÁRIO DE ACORDES 🎸'),
        backgroundColor: const Color(0xFF0E1622),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _iniciarMicrofone,
        backgroundColor: Colors.redAccent,
        child: const Icon(Icons.mic, color: Colors.white),
      ),
      body: _carregando 
        ? const Center(child: CircularProgressIndicator()) 
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'Violão', label: Text('Violão')),
                    ButtonSegment(value: 'Cavaco', label: Text('Cavaco')),
                  ],
                  selected: {_instrumento},
                  onSelectionChanged: (newSelection) {
                    setState(() => _instrumento = newSelection.first);
                  },
                ),
              ),
              Expanded(
                child: ListView(
                  children: (_dadosAcordes[_instrumento] as Map<String, dynamic>?)?.keys.map((nota) {
                    return ListTile(
                      title: Text(nota, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      trailing: IconButton(
                        icon: const Icon(Icons.play_circle_fill, color: Colors.blueAccent, size: 32),
                        onPressed: () async {
                          await _audioController.carregarAudio('assets/audio/$nota.mp3');
                          await _audioController.tocar();
                        },
                      ),
                      onTap: () {
                        debugPrint("Nota selecionada: $nota");
                      },
                    );
                  }).toList() ?? [const Center(child: Text("Nenhum acorde encontrado"))],
                ),
              ),
            ],
          ),
    );
  }
}