import 'package:flutter/material.dart';
import '../main.dart'; // Mantém o alinhamento com as cores globais

class FerramentasPage extends StatefulWidget {
  const FerramentasPage({super.key});

  @override
  State<FerramentasPage> createState() => _FerramentasPageState();
}

class _FerramentasPageState extends State<FerramentasPage> {
  int _bpm = 120;
  bool _metronomeAtivo = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UTILITÁRIOS & FERRAMENTAS 🔧', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        backgroundColor: const Color(0xFF0E1622),
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // CARD 1: METRÓNOMO DIGITAL RÁPIDO
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF0E1622),
              borderRadius: BorderRadius.circular(8),
              border: const Border(left: BorderSide(color: AppColors.primary, width: 4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.av_timer, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    const Text('Metrónomo Base', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline, color: Colors.grey),
                      onPressed: () => setState(() => _bpm > 40 ? _bpm-- : null),
                    ),
                    Text('$_bpm BPM', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline, color: Colors.grey),
                      onPressed: () => setState(() => _bpm < 250 ? _bpm++ : null),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _metronomeAtivo ? Colors.red.withOpacity(0.3) : const Color(0xFF131D2C),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      onPressed: () => setState(() => _metronomeAtivo = !_metronomeAtivo),
                      child: Text(_metronomeAtivo ? 'PARAR' : 'INICIAR', style: TextStyle(fontSize: 11, color: _metronomeAtivo ? Colors.red : AppColors.primary, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // CARD 2: AFINADOR DE OUVIDO (REFERÊNCIA DE NOTAS)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF0E1622),
              borderRadius: BorderRadius.circular(8),
              border: const Border(left: BorderSide(color: Colors.blueAccent, width: 4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.music_note, color: Colors.blueAccent, size: 20),
                    const SizedBox(width: 8),
                    Text('Notas de Referência (Afinador)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ['E (Mi)', 'A (Lá)', 'D (Ré)', 'G (Sol)', 'B (Si)', 'E (Mi)'].map((nota) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF131D2C),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      onPressed: () {
                        // Lógica futura: Tocar áudio da nota senoidal correspondente
                      },
                      child: Text(nota, style: const TextStyle(fontSize: 11, color: Colors.white)),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // CARD 3: CRONÓMETRO DE SETLIST (BLOCO)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF0E1622),
              borderRadius: BorderRadius.circular(8),
              border: const Border(left: BorderSide(color: Colors.greenAccent, width: 4)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.timer, color: Colors.greenAccent, size: 20),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tempo de Show (Setlist)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        Text('Controlo de duração do bloco', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
                Text('00:00', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.greenAccent)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}