import 'package:flutter/material.dart';

// Modelo simples para estruturar as pistas neste módulo
class StemTrack {
  final String nome;
  final Color corPainel;
  bool isMuted;
  double volume;

  StemTrack({
    required this.nome,
    required this.corPainel,
    this.isMuted = false,
    this.volume = 0.8,
  });
}

class MixerPage extends StatefulWidget {
  const MixerPage({super.key});

  @override
  State<MixerPage> createState() => _MixerPageState();
}

class _MixerPageState extends State<MixerPage> {
  double _velocidadeGlobal = 1.0;
  double _tomGlobal = 1.0;

  // Lista de canais baseada no seu bloco de notas
  final List<StemTrack> _stems = [
    StemTrack(nome: "Voz", corPainel: Colors.purpleAccent),
    StemTrack(nome: "Violão", corPainel: Colors.orangeAccent),
    StemTrack(nome: "Cavaco", corPainel: Colors.yellowAccent),
    StemTrack(nome: "Baixo", corPainel: Colors.blueAccent),
    StemTrack(nome: "Percussão", corPainel: Colors.greenAccent),
    StemTrack(nome: "Bateria / Sopro", corPainel: Colors.redAccent),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Console Mixer Multipistas 🎛️', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0E1622),
      ),
      body: Column(
        children: [
          // Painel Superior: Controles de Tom e Tempo
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text("Tom: ${_tomGlobal.toStringAsFixed(1)}x", style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      Slider(
                        value: _tomGlobal, 
                        min: 0.5, 
                        max: 1.5, 
                        activeColor: const Color(0xFFE5A93C), 
                        onChanged: (v) => setState(() => _tomGlobal = v)
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text("Tempo: ${(_velocidadeGlobal * 100).toInt()}%", style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      Slider(
                        value: _velocidadeGlobal, 
                        min: 0.5, 
                        max: 1.5, 
                        activeColor: const Color(0xFFE5A93C), 
                        onChanged: (v) => setState(() => _velocidadeGlobal = v)
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white10, height: 1),

          // Grade com os Faders Verticais (Estilo Rack de Estúdio)
          Expanded(
            child: GridView.builder(
              itemCount: _stems.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.65,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final track = _stems[index];
                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF0E1622),
                    border: Border(top: BorderSide(color: track.isMuted ? Colors.grey : track.corPainel, width: 3)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Text(track.nome, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: track.isMuted ? Colors.grey : track.corPainel)),
                      Expanded(
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Slider(
                            value: track.isMuted ? 0.0 : track.volume, 
                            min: 0.0, 
                            max: 1.0,
                            activeColor: track.isMuted ? Colors.grey : track.corPainel,
                            onChanged: track.isMuted ? null : (v) => setState(() => track.volume = v),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 26,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: track.isMuted ? Colors.red.withOpacity(0.3) : const Color(0xFF131D2C),
                            padding: EdgeInsets.zero,
                          ),
                          onPressed: () => setState(() => track.isMuted = !track.isMuted),
                          child: Text("MUTE", style: TextStyle(fontSize: 9, color: track.isMuted ? Colors.red : Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}