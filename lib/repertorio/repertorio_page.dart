import 'package:flutter/material.dart';
import '../main.dart'; // Importa os modelos de dados e a paleta de cores globais

class RepertorioPage extends StatefulWidget {
  const RepertorioPage({super.key});

  @override
  State<RepertorioPage> createState() => _RepertorioPageState();
}

// REMOVIDO: A classe _MixerPageState que estava aqui incorretamente

class _RepertorioPageState extends State<RepertorioPage> {
  final TextEditingController _searchController = TextEditingController();
  String _filtroCategoria = 'Todos';

  // Base de dados mockada
  final List<Map<String, String>> _musicasExemplo = [
    {'titulo': 'Tanto Faz', 'artista': 'Arranjo Original', 'tom': 'Am', 'ritmo': 'Samba'},
    {'titulo': 'Verdade', 'artista': 'Zeca Pagodinho', 'tom': 'F', 'ritmo': 'Samba'},
    {'titulo': 'Deixa Acontecer', 'artista': 'Grupo Revelação', 'tom': 'D', 'ritmo': 'Pagode'},
    {'titulo': 'Cheia de Manias', 'artista': 'Raça Negra', 'tom': 'Bm', 'ritmo': 'Pagode'},
    {'titulo': 'Evidências', 'artista': 'Chitãozinho & Xororó', 'tom': 'E', 'ritmo': 'Sertanejo'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MEU REPERTÓRIO 🎵', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        backgroundColor: const Color(0xFF0E1622),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Buscar música, artista ou tom...',
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                prefixIcon: const Icon(Icons.search, color: AppColors.primary, size: 20),
                filled: true,
                fillColor: const Color(0xFF0E1622),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),
          SizedBox(
            height: 35,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: ['Todos', 'Samba', 'Pagode', 'Sertanejo'].map((categoria) {
                final bool isSelected = _filtroCategoria == categoria;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(categoria, style: TextStyle(fontSize: 12, color: isSelected ? Colors.black : Colors.white)),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    backgroundColor: const Color(0xFF0E1622),
                    checkmarkColor: Colors.black,
                    onSelected: (selected) {
                      if (selected) setState(() => _filtroCategoria = categoria);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: _musicasExemplo.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                final musica = _musicasExemplo[index];
                if (_filtroCategoria != 'Todos' && musica['ritmo'] != _filtroCategoria) {
                  return const SizedBox.shrink();
                }
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0E1622),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF131D2C),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          musica['tom']!,
                          style: const TextStyle(color: AppColors.textCifra, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                    ),
                    title: Text(musica['titulo']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
                    subtitle: Text("${musica['artista']} • ${musica['ritmo']}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 14),
                    onTap: () {},
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}