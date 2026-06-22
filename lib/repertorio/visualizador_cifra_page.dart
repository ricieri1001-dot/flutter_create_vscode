import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../ferramentas/audio_controller.dart';
import '../ferramentas/cifra_parser.dart';

class VisualizadorCifraPage extends StatefulWidget {
  final String nomeMusica;
  final String arquivoCifra;
  final String arquivoAudio;
  final String? conteudoDireto;

  const VisualizadorCifraPage({
    super.key,
    required this.nomeMusica,
    required this.arquivoCifra,
    required this.arquivoAudio,
    this.conteudoDireto,
  });

  @override
  State<VisualizadorCifraPage> createState() => _VisualizadorCifraPageState();
}

class _VisualizadorCifraPageState extends State<VisualizadorCifraPage> {
  final AudioController _audioController = AudioController();
  final ScrollController _scrollController = ScrollController();
  
  String _conteudoCifra = "Carregando cifra...";
  bool _estaTocando = false;
  StreamSubscription? _audioSubscription;

  // --- MÓDULO ADITIVO: CONFIGURAÇÃO DE CORES (6 TEMAS) ---
  int _temaIndex = 0;
  final List<Map<String, Color>> _paletas = [
    {'fundo': const Color(0xFF070B11), 'texto': Colors.white},       // Padrão
    {'fundo': Colors.white,            'texto': Colors.black},       // Branco
    {'fundo': Colors.black,            'texto': Colors.white},       // Preto
    {'fundo': Color(0xFF1A237E),       'texto': Colors.white},       // Azul
    {'fundo': Color(0xFFB71C1C),       'texto': Colors.white},       // Vermelho
    {'fundo': Color(0xFFF57F17),       'texto': Colors.black},       // Amarelo
  ];

  void _proximoTema() => setState(() => _temaIndex = (_temaIndex + 1) % _paletas.length);
  // -------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _entrarTelaCheia();
    _iniciarTudo();
  }

  void _entrarTelaCheia() => SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  void _sairTelaCheia() => SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  Future<void> _iniciarTudo() async {
    if (widget.conteudoDireto != null && widget.conteudoDireto!.isNotEmpty) {
      setState(() => _conteudoCifra = widget.conteudoDireto!);
    } else {
      final texto = await CifraParser.carregarCifra(widget.arquivoCifra);
      setState(() => _conteudoCifra = texto);
    }
    
    await _audioController.carregarAudio(widget.arquivoAudio);

    _audioController.player.positionStream.listen((posicao) {
      final duracaoTotal = _audioController.player.duration;
      if (duracaoTotal != null && duracaoTotal.inMilliseconds > 0 && _scrollController.hasClients) {
        double progresso = posicao.inMilliseconds / duracaoTotal.inMilliseconds;
        double maxScroll = _scrollController.position.maxScrollExtent;
        _scrollController.animateTo(
          maxScroll * progresso,
          duration: const Duration(milliseconds: 300),
          curve: Curves.linear,
        );
      }
    });

    _audioController.player.playerStateStream.listen((state) {
      if (mounted) setState(() => _estaTocando = state.playing);
    });
  }

  void _alternarPlayPause() {
    if (_estaTocando) {
      _audioController.player.pause();
    } else {
      _audioController.tocar();
    }
  }

  @override
  void dispose() {
    _audioSubscription?.cancel();
    _scrollController.dispose();
    _audioController.dispose();
    _sairTelaCheia();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _paletas[_temaIndex]['fundo'],
      appBar: AppBar(
        title: Text(widget.nomeMusica),
        actions: [
          IconButton(
            icon: const Icon(Icons.palette),
            onPressed: _proximoTema,
            tooltip: "Alterar Tema",
          ),
          IconButton(
            icon: const Icon(Icons.fullscreen_exit),
            onPressed: () => Navigator.pop(context),
            tooltip: "Sair do Visualizador",
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          child: Text(
            _conteudoCifra, 
            style: TextStyle(
              fontFamily: 'Courier', 
              fontSize: 16,
              color: _paletas[_temaIndex]['texto'],
              height: 1.5,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFE5A93C),
        child: Icon(_estaTocando ? Icons.pause : Icons.play_arrow, color: Colors.black),
        onPressed: _alternarPlayPause,
      ),
    );
  }
}