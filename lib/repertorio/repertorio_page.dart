import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../main.dart'; // Importa os modelos de dados e a paleta de cores globais

class RepertorioPage extends StatefulWidget {
  const RepertorioPage({super.key});

  @override
  State<RepertorioPage> createState() => _RepertorioPageState();
}

class _RepertorioPageState extends State<RepertorioPage> {
  final TextEditingController _searchController = TextEditingController();
  String _filtroCategoria = 'Todos';
  
  List<dynamic> _todasAsMusicas = [];
  List<dynamic> _musicasFiltradas = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _inicializarRepertorio();
  }

  // Carrega o catálogo JSON local usando os métodos nativos estáveis do Flutter
  Future<void> _inicializarRepertorio() async {
    try {
      final String resposta = await rootBundle.loadString('assets/data/repertorio.json');
      final List<dynamic> dados = json.decode(resposta);
      setState(() {
        _todasAsMusicas = dados;
        _musicasFiltradas = dados;
        _carregando = false;
      });
    } catch (e) {
      setState(() {
        _carregando = false;
      });
    }
  }

  // Executa o filtro combinado (Barra de Busca + ChoiceChips de Ritmo)
  void _aplicarFiltros() {
    final termo = _searchController.text.toLowerCase();

    setState(() {
      _musicasFiltradas = _todasAsMusicas.where((musica) {
        final titulo = (musica['titulo'] ?? '').toString().toLowerCase();
        final artista = (musica['artista'] ?? '').toString().toLowerCase();
        final tom = (musica['tom'] ?? '').toString().toLowerCase();
        final ritmo = (musica['ritmo'] ?? '').toString();

        // Valida o texto digitado (busca por título, artista ou tom)
        final bateTexto = titulo.contains(termo) || artista.contains(termo) || tom.contains(termo);
        
        // Valida a categoria/ritmo selecionado
        final bateCategoria = _filtroCategoria == 'Todos' || ritmo == _filtroCategoria;

        return bateTexto && bateCategoria;
      }).toList();
    });
  }

  // Carrega o texto puro da cifra e abre o visualizador de forma segura
  void _abrirCifra(BuildContext context, Map<String, dynamic> musica) async {
    try {
      final String conteudoCifra = await rootBundle.loadString(musica['caminhoTxt']);
      
      if (!context.mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VisualizadorCifraPage(
            titulo: musica['titulo'],
            artista: musica['artista'],
            tom: musica['tom'],
            corpoCifra: conteudoCifra,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Arquivo de cifra não encontrado.")),
      );
    }
  }

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
          // Barra de Busca
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
              onChanged: (value) => _aplicarFiltros(),
            ),
          ),
          
          // Carrossel de Categorias (Ritmos)
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
                      if (selected) {
                        setState(() {
                          _filtroCategoria = categoria;
                        });
                        _aplicarFiltros();
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          
          // Lista de Músicas Vinda do JSON
          Expanded(
            child: _carregando
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : _musicasFiltradas.isEmpty
                    ? const Center(
                        child: Text(
                          "Nenhuma música encontrada.",
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _musicasFiltradas.length,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemBuilder: (context, index) {
                          final dynamic item = _musicasFiltradas[index];
                          
                          // Convertemos para um Map seguro antes do uso
                          final Map<String, dynamic> musica = Map<String, dynamic>.from(item);

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
                                    musica['tom'] ?? '',
                                    style: const TextStyle(color: AppColors.textCifra, fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                ),
                              ),
                              title: Text(
                                musica['titulo'] ?? '', 
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                              ),
                              subtitle: Text(
                                "${musica['artista'] ?? ''} • ${musica['ritmo'] ?? ''}", 
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 14),
                              onTap: () => _abrirCifra(context, musica),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

// ===========================================================================
// TELA NATIVA DO VISUALIZADOR DA CIFRA (FONTE MONOSPACED PARA ALINHAMENTO)
// ===========================================================================
class VisualizadorCifraPage extends StatelessWidget {
  final String titulo;
  final String artista;
  final String tom;
  final String corpoCifra;

  const VisualizadorCifraPage({
    super.key,
    required this.titulo,
    required this.artista,
    required this.tom,
    required this.corpoCifra,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050B14),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E1622),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titulo, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
            Text(artista, style: const TextStyle(color: Colors.grey, fontSize: 11)),
          ],
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF131D2C),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "Tom: $tom",
                  style: const TextStyle(color: AppColors.textCifra, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          corpoCifra,
          style: const TextStyle(
            fontFamily: 'Courier', // Obrigatório para manter os acordes perfeitamente alinhados sobre o texto
            fontSize: 14,
            color: Colors.white70,
            height: 1.6,
          ),
        ),
      ),
    );
  }
}