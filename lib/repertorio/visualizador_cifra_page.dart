import 'package:flutter/material.dart';
import '../ferramentas/audio_controller.dart';
import '../ferramentas/cifra_parser.dart';

class VisualizadorCifraPage extends StatefulWidget {
  final String nomeMusica;
  final String arquivoCifra;
  final String arquivoAudio;

  const VisualizadorCifraPage({
    super.key,
    required this.nomeMusica,
    required this.arquivoCifra,
    required this.arquivoAudio,
  });

  @override
  State<VisualizadorCifraPage> createState() => _VisualizadorCifraPageState();
}

class _VisualizadorCifraPageState extends State<VisualizadorCifraPage> {
  final AudioController _audioController = AudioController();
  String _conteudoCifra = "Carregando cifra...";

  @override
  void initState() {
    super.initState();
    _iniciarTudo();
  }

  Future<void> _iniciarTudo() async {
    // Carrega o texto da cifra
    final texto = await CifraParser.carregarCifra(widget.arquivoCifra);
    setState(() => _conteudoCifra = texto);
    
    // Prepara o áudio
    await _audioController.carregarAudio(widget.arquivoAudio);
  }

  @override
  void dispose() {
    _audioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.nomeMusica)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Text(_conteudoCifra, style: const TextStyle(fontFamily: 'Courier', fontSize: 16)),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.play_arrow),
        onPressed: () => _audioController.tocar(),
      ),
    );
  }
}