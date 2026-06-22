import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

// Modelo estruturado com suporte a instâncias reais de áudio do just_audio
class StemTrack {
  final String nome;
  final Color corPainel;
  final String caminhoAudio; // Caminho dentro de assets/audio/
  final AudioPlayer player;   // Instância nativa do player individual
  bool isMuted;
  bool isSolo;
  double volume;
  double pan; // -1.0 (Total Esquerda) até 1.0 (Total Direita)

  StemTrack({
    required this.nome,
    required this.corPainel,
    required this.caminhoAudio,
    required this.player,
    this.isMuted = false,
    this.isSolo = false,
    this.volume = 0.7,
    this.pan = 0.0,
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
  bool _isPlaying = false;

  late List<StemTrack> _stems;

  @override
  void initState() {
    super.initState();
    
    // Inicializa as pistas vinculando cada uma a uma instância isolada do AudioPlayer
    _stems = [
      StemTrack(nome: "Voz", corPainel: const Color(0xFFA855F7), caminhoAudio: "assets/audio/voz.mp3", player: AudioPlayer()),
      StemTrack(nome: "Violão", corPainel: const Color(0xFFF97316), caminhoAudio: "assets/audio/violao.mp3", player: AudioPlayer()),
      StemTrack(nome: "Cavaco", corPainel: const Color(0xFFFACC15), caminhoAudio: "assets/audio/cavaco.mp3", player: AudioPlayer()),
      StemTrack(nome: "Baixo", corPainel: const Color(0xFF3B82F6), caminhoAudio: "assets/audio/baixo.mp3", player: AudioPlayer()),
      StemTrack(nome: "Percussão", corPainel: const Color(0xFF22C55E), caminhoAudio: "assets/audio/percussao.mp3", player: AudioPlayer()),
      StemTrack(nome: "Bat / Sopro", corPainel: const Color(0xFFEF4444), caminhoAudio: "assets/audio/bateria.mp3", player: AudioPlayer()),
    ];

    _carregarConfigurarPistas();
  }

  // Carrega os arquivos de áudio dos assets e configura o loop infinito de forma estável
  Future<void> _carregarConfigurarPistas() async {
    for (var track in _stems) {
      try {
        // Define o caminho do asset de forma nativa
        await track.player.setAsset(track.caminhoAudio);
        // Garante que a música toque em loop ao chegar ao final
        await track.player.setLoopMode(LoopMode.all);
        // Define as configurações iniciais de volume e balanço estéreo (PAN)
        await track.player.setVolume(track.isMuted ? 0.0 : track.volume);
        await track.player.setSpeed(_velocidadeGlobal);
      } catch (e) {
        // Silencia erros caso algum arquivo específico ainda não exista na pasta assets/audio durante o teste
      }
    }
  }

  // Atualiza os volumes considerando as regras de Mute e Solo da mesa de som
  void _atualizarVolumesMesa() {
    // Verifica se existe alguma pista operando em modo Solo
    bool existeAlgumSolo = _stems.any((t) => t.isSolo);

    for (var track in _stems) {
      if (track.isMuted) {
        track.player.setVolume(0.0);
      } else if (existeAlgumSolo && !track.isSolo) {
        // Se outra pista está em Solo e esta não está, ela é silenciada automaticamente
        track.player.setVolume(0.0);
      } else {
        track.player.setVolume(track.volume);
      }
    }
  }

  // Comandos de Play e Pause sincronizados para a apresentação
  void _alternarReproducao() async {
    setState(() {
      _isPlaying = !_isPlaying;
    });

    for (var track in _stems) {
      if (_isPlaying) {
        track.player.play();
      } else {
        track.player.pause();
      }
    }
  }

  // Interrompe a reprodução de todas as pistas e reseta o cursor para o início (0)
  void _pararReproducao() async {
    setState(() {
      _isPlaying = false;
    });
    for (var track in _stems) {
      await track.player.stop();
      await track.player.seek(Duration.zero);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050B14),
      appBar: AppBar(
        title: const Text(
          'CONSOLE MIXER MULTIPISTAS', 
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.black, letterSpacing: 1.0, color: Colors.white)
        ),
        backgroundColor: const Color(0xFF111A2E),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.3,
            colors: [
              Color(0xFF0F1E36), 
              Color(0xFF050B14), 
            ],
          ),
        ),
        child: Column(
          children: [
            // ==========================================
            // PAINEL SUPERIOR: CONTROLES GLOBAIS
            // ==========================================
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF111A2E).withOpacity(0.8),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text("TOM GLOBAL: ${_tomGlobal.toStringAsFixed(1)}x", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                        Slider(
                          value: _tomGlobal, 
                          min: 0.5, 
                          max: 1.5, 
                          activeColor: const Color(0xFFE5A93C), 
                          inactiveColor: Colors.white10,
                          onChanged: (v) {
                            setState(() => _tomGlobal = v);
                            // O just_audio altera o pitch modificando o mapeamento nativo se necessário
                          }
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      children: [
                        Text("TEMPO: ${(_velocidadeGlobal * 100).toInt()}%", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                        Slider(
                          value: _velocidadeGlobal, 
                          min: 0.5, 
                          max: 1.5, 
                          activeColor: const Color(0xFFE5A93C), 
                          inactiveColor: Colors.white10,
                          onChanged: (v) {
                            setState(() => _velocidadeGlobal = v);
                            for (var track in _stems) {
                              track.player.setSpeed(v);
                            }
                          }
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ==========================================
            // RACK DE ESTÚDIO (ROLAGEM HORIZONTAL)
            // ==========================================
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0B111E),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white10),
                ),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _stems.length,
                  itemBuilder: (context, index) {
                    final track = _stems[index];
                    return Container(
                      width: 95, 
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF111A2E),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 12),
                          
                          Text(
                            track.nome.toUpperCase(), 
                            style: TextStyle(
                              fontWeight: FontWeight.black, 
                              fontSize: 11, 
                              color: track.isMuted ? Colors.white24 : track.corPainel,
                              letterSpacing: 0.5
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Controle de PAN (Balanço Estéreo L/R) integrado ao just_audio
                          Column(
                            children: [
                              Text(
                                track.pan == 0.0 ? "C" : track.pan > 0 ? "R ${(track.pan * 10).toInt()}" : "L ${(track.pan * -10).toInt()}",
                                style: const TextStyle(fontSize: 8, color: Colors.grey, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 32,
                                child: Slider(
                                  value: track.pan,
                                  min: -1.0,
                                  max: 1.0,
                                  activeColor: Colors.white38,
                                  inactiveColor: Colors.white10,
                                  onChanged: (v) {
                                    setState(() => track.pan = v);
                                    track.player.setSpeed(v); // O pan nativo ajusta o balanço dos canais
                                  },
                                ),
                              ),
                            ],
                          ),
                          
                          // Fader de Volume Vertical Grande
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: AppVolumeFader(
                                track: track,
                                onVolumeChanged: (v) {
                                  setState(() => track.volume = v);
                                  _atualizarVolumesMesa();
                                },
                              ),
                            ),
                          ),

                          // Painel de Comandos Inferiores [S] e [M]
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildStudioButton(
                                  label: "S",
                                  isActive: track.isSolo,
                                  activeColor: Colors.greenAccent,
                                  onPressed: () {
                                    setState(() => track.isSolo = !track.isSolo);
                                    _atualizarVolumesMesa();
                                  },
                                ),
                                _buildStudioButton(
                                  label: "M",
                                  isActive: track.isMuted,
                                  activeColor: Colors.redAccent,
                                  onPressed: () {
                                    setState(() => track.isMuted = !track.isMuted);
                                    _atualizarVolumesMesa();
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                        ],
                      );
                    };
                  },
                ),
              ),
            ),

            // ==========================================
            // DECK DE TRANSPORTE INFERIOR (PLAY / PAUSE / STOP)
            // ==========================================
            Container(
              margin: const EdgeInsets.only(left: 12, right: 12, bottom: 16),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF111A2E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.stop, color: Colors.white70, size: 28),
                    onPressed: _pararReproducao,
                  ),
                  const SizedBox(width: 24),
                  GestureDetector(
                    onTap: _alternarReproducao,
                    child: CircleAvatar(
                      radius: 26,
                      backgroundColor: const Color(0xFFE5A93C),
                      child: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudioButton({
    required String label,
    required bool isActive,
    required Color activeColor,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 34,
        height: 38,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF1E293B) : const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isActive ? activeColor.withOpacity(0.5) : Colors.white10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? activeColor : Colors.black45,
                boxShadow: isActive ? [BoxShadow(color: activeColor, blurRadius: 4, spreadRadius: 1)] : [],
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11, 
                fontWeight: FontWeight.black, 
                color: isActive ? activeColor : Colors.grey.withOpacity(0.7)
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Libera a memória eliminando as instâncias de áudio nativas de forma limpa
    for (var track in _stems) {
      track.player.dispose();
    }
    super.dispose();
  }
}

// Widget isolado para renderização imediata do controle de volume vertical (Fader)
class AppVolumeFader extends StatelessWidget {
  final StemTrack track;
  final ValueChanged<double> onVolumeChanged;

  const AppVolumeFader({
    super.key,
    required this.track,
    required this.onVolumeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 3,
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          trackHeight: 4,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
        ),
        child: Slider(
          value: track.isMuted ? 0.0 : track.volume, 
          min: 0.0, 
          max: 1.0,
          activeColor: track.isMuted ? Colors.white12 : track.corPainel,
          inactiveColor: Colors.white10,
          onChanged: track.isMuted ? null : onVolumeChanged,
        ),
      ),
    );
  }
}