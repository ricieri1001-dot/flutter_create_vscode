import 'dart:async';
import 'dart:math' as math; // Adicionado para calcular a matemática do afinador de forma estável
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pitch_detector_dart/pitch_detector_dart.dart';
import 'package:record/record.dart';

class FerramentasPage extends StatefulWidget {
  const FerramentasPage({super.key});

  @override
  State<FerramentasPage> createState() => _FerramentasPageState();
}

class _FerramentasPageState extends State<FerramentasPage> with SingleTickerProviderStateMixin {
  int _bpm = 120;
  bool _metronomeAtivo = false;
  String _instrumentoSelecionado = "Violão";
  late AnimationController _penduloController;
  late AudioPlayer _audioPlayer; 

  final _audioRecorder = AudioRecorder();
  String _notaDetectada = "--";
  bool _afinadorAtivo = false;

  late PitchDetector _pitchDetector;
  StreamSubscription<List<int>>? _audioStreamSubscription;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _pitchDetector = PitchDetector(44100, 2048);

    _penduloController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) _penduloController.reverse();
        else if (status == AnimationStatus.dismissed) _penduloController.forward();
      });
  }

  // CÓDIGO CORRIGIDO: Conversão matemática real, limpa e estável sem erros de sintaxe
  String _converterHzParaNota(double frequency) {
    if (frequency < 20 || frequency > 4000) return "--";
    
    // Verificação precisa por faixas de frequência das cordas soltas
    if (frequency >= 79.0 && frequency <= 85.0) return "E (6ª Corda)";
    if (frequency >= 107.0 && frequency <= 113.0) return "A (5ª Corda)";
    if (frequency >= 143.0 && frequency <= 150.0) return "D (4ª Corda)";
    if (frequency >= 192.0 && frequency <= 199.0) return "G (3ª Corda)";
    if (frequency >= 242.0 && frequency <= 251.0) return "B (2ª Corda)";
    if (frequency >= 324.0 && frequency <= 335.0) return "E (1ª Corda)";
    
    if (_instrumentoSelecionado == "Cavaco") {
      if (frequency >= 290.0 && frequency <= 300.0) return "D (1ª Corda)";
    }

    // Caso seja outra nota fora das cordas soltas, calcula via Logaritmo estável
    try {
      const notas = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"];
      int noteIndex = (12 * (math.log(frequency / 440.0) / math.log(2))).round() + 69;
      String nomeNota = notas[(noteIndex - 12) % 12];
      return "$nomeNota (${frequency.toStringAsFixed(1)} Hz)";
    } catch (e) {
      return "${frequency.toStringAsFixed(1)} Hz";
    }
  }

  void _iniciarAnaliseAudio() async {
    try {
      final stream = await _audioRecorder.startStream(const RecordConfig(
        encoder: AudioEncoder.pcm16bits,
        sampleRate: 44100,
        numChannels: 1,
      ));

      _audioStreamSubscription = stream.listen((data) {
        if (!_afinadorAtivo) return;
        final buffer = data.buffer.asInt16List();
        final result = _pitchDetector.run(buffer);
        if (result != null && result.pitched) {
          setState(() {
            _notaDetectada = _converterHzParaNota(result.pitch);
          });
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao iniciar captura do microfone: $e")),
      );
    }
  }

  void _pararAnaliseAudio() async {
    await _audioStreamSubscription?.cancel();
    _audioStreamSubscription = null;
    await _audioRecorder.stop();
  }

  void _alternarMetronome() {
    setState(() {
      _metronomeAtivo = !_metronomeAtivo;
      if (_metronomeAtivo) {
        _penduloController.duration = Duration(milliseconds: (60000 / _bpm).round());
        _penduloController.forward();
      } else {
        _penduloController.stop();
        _penduloController.reset();
      }
    });
  }

  Future<void> _tocarNota(String nomeNota) async {
    try {
      await _audioPlayer.setAsset('assets/audio/$nomeNota.mp3');
      _audioPlayer.play();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Adicione o arquivo $nomeNota.mp3 em assets/audio/")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050B14),
      appBar: AppBar(
        title: const Text('UTILITÁRIOS E FERRAMENTAS', style: TextStyle(fontSize: 14, fontWeight: FontWeight.black, letterSpacing: 1.0, color: Colors.white)),
        backgroundColor: const Color(0xFF111A2E),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: RadialGradient(center: Alignment.center, radius: 1.3, colors: [Color(0xFF0F1E36), Color(0xFF050B14)])),
        child: ListView(
          padding: const EdgeInsets.all(18.0),
          children: [
            _buildMetronomo(),
            const SizedBox(height: 18),
            _buildDicionario(),
            const SizedBox(height: 18),
            _buildAfunadorCromaticoReal(),
            const SizedBox(height: 18),
            _buildNotasDeReferencia(),
          ],
        ),
      ),
    );
  }

  Widget _buildMetronomo() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: const Color(0xFF111A2E), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white10)),
      child: Column(children: [
        const Row(children: [Icon(Icons.av_timer, color: Color(0xFFE5A93C), size: 22), SizedBox(width: 8), Text('Metrônomo Profissional', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white))]),
        const SizedBox(height: 20),
        AnimatedBuilder(animation: _penduloController, builder: (context, child) => Align(alignment: Alignment(_penduloController.value * 2 - 1, 0), child: Container(width: 24, height: 24, decoration: BoxDecoration(shape: BoxShape.circle, color: _metronomeAtivo ? const Color(0xFF22C55E) : const Color(0xFFE5A93C))))),
        const SizedBox(height: 24),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [IconButton(icon: const Icon(Icons.remove_circle_outline, color: Colors.grey), onPressed: () => setState(() => _bpm--)), Text('$_bpm BPM', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), IconButton(icon: const Icon(Icons.add_circle_outline, color: Colors.grey), onPressed: () => setState(() => _bpm++))]),
          ElevatedButton(onPressed: _alternarMetronome, child: Text(_metronomeAtivo ? 'PARAR' : 'INICIAR'))
        ])
      ]),
    );
  }

  Widget _buildDicionario() {
    int quantidadeCordas = _instrumentoSelecionado == "Violão" ? 6 : 4;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: const Color(0xFF111A2E), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white10)),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Dicionário: Acorde C (Dó)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          DropdownButton<String>(
            value: _instrumentoSelecionado, 
            dropdownColor: const Color(0xFF111A2E), 
            items: ['Violão', 'Cavaco'].map((v) => DropdownMenuItem(value: v, child: Text(v, style: const TextStyle(color: Colors.white)))).toList(), 
            onChanged: (v) => setState(() => _instrumentoSelecionado = v!)
          )
        ]),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.black23,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white10)
          ),
          child: Column(
            children: List.generate(4, (trasteIndex) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(quantidadeCordas, (cordaIndex) {
                  bool temNota = false;
                  if (_instrumentoSelecionado == "Violão") {
                    if (trasteIndex == 0 && cordaIndex == 4) temNota = true; 
                    if (trasteIndex == 1 && cordaIndex == 2) temNota = true; 
                    if (trasteIndex == 2 && cordaIndex == 1) temNota = true; 
                  } else {
                    if (trasteIndex == 0 && cordaIndex == 2) temNota = true;
                    if (trasteIndex == 1 && cordaIndex == 0) temNota = true;
                  }

                  return Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade700, width: 2),
                        right: BorderSide(color: Colors.amber.shade700, width: cordaIndex < quantidadeCordas - 1 ? 1 : 0),
                      )
                    ),
                    child: temNota 
                        ? Container(
                            width: 14, 
                            height: 14, 
                            decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF3B82F6))
                          ) 
                        : null,
                  );
                }),
              );
            }),
          ),
        ),
      ]),
    );
  }

  Widget _buildAfunadorCromaticoReal() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: const Color(0xFF111A2E), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white10)),
      child: Column(children: [
        const Row(children: [Icon(Icons.mic, color: Color(0xFF22C55E), size: 22), SizedBox(width: 8), Text('Reconhecedor de Acordes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white))]),
        const SizedBox(height: 10),
        Text(_notaDetectada, style: const TextStyle(fontSize: 34, color: Color(0xFF22C55E), fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            if (await Permission.microphone.request().isGranted) {
              setState(() {
                _afinadorAtivo = !_afinadorAtivo;
                if (_afinadorAtivo) {
                  _iniciarAnaliseAudio();
                } else {
                  _pararAnaliseAudio();
                  _notaDetectada = "--";
                }
              });
            }
          }, 
          child: Text(_afinadorAtivo ? "Parar Afinador" : "Ativar Afinador"),
        ),
      ]),
    );
  }

  Widget _buildNotasDeReferencia() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: const Color(0xFF111A2E), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white10)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Row(children: [Icon(Icons.music_video, color: Color(0xFFA855F7), size: 22), SizedBox(width: 8), Text('Notas de Referência', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white))]),
        const SizedBox(height: 16),
        Wrap(spacing: 8, runSpacing: 8, children: ['E', 'A', 'D', 'G', 'B', 'E2'].map((n) => ElevatedButton(onPressed: () => _tocarNota(n), child: Text(n))).toList()),
      ]),
    );
  }

  @override
  void dispose() {
    _audioStreamSubscription?.cancel();
    _audioPlayer.dispose();
    _penduloController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }
}