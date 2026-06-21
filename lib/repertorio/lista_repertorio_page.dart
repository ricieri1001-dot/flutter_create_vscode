import 'package:flutter/material.dart';
import 'visualizador_cifra_page.dart';

class ListaRepertorioPage extends StatelessWidget {
  // Lista de arquivos que temos na pasta assets/cifras/
  final List<Map<String, String>> musicas = [
    {"titulo": "Dói Demais", "arquivo": "Doi_Demais.txt"},
  ];

  ListaRepertorioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Meu Repertório")),
      body: ListView.builder(
        itemCount: musicas.length,
        itemBuilder: (context, index) {
          final musica = musicas[index];
          return ListTile(
            title: Text(musica["titulo"]!),
            trailing: const Icon(Icons.music_note),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VisualizadorCifraPage(
                    nomeMusica: musica["titulo"]!,
                    arquivoCifra: musica["arquivo"]!,
                    arquivoAudio: "", // Futuramente, adicione o caminho do áudio aqui
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}