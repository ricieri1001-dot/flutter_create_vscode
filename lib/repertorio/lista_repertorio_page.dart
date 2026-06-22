import 'package:flutter/material.dart';
import 'visualizador_cifra_page.dart';

class ListaRepertorioPage extends StatefulWidget {
  const ListaRepertorioPage({super.key});

  @override
  State<ListaRepertorioPage> createState() => ListaRepertorioPageState();
}

class ListaRepertorioPageState extends State<ListaRepertorioPage> {
  // Lista de músicas transformada em dinâmica para permitir inserções em tempo real
  final List<Map<String, String>> musicas = [
    {"titulo": "Dói Demais", "arquivo": "Doi_Demais.txt", "conteudoDireto": ""},
  ];

  /// Método público que o main.dart chamará de forma cirúrgica para injetar
  /// a cifra capturada da web diretamente na lista do músico.
  void adicionarMusicaImportada(String titulo, String textoCifra) {
    setState(() {
      musicas.add({
        "titulo": titulo,
        "arquivo": "", // Não usa arquivo físico pois veio da web
        "conteudoDireto": textoCifra, // Injeta o texto extraído pelo parser
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Meu Repertório")),
      body: musicas.isEmpty
          ? const Center(
              child: Text(
                "Nenhuma música no repertório.",
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: musicas.length,
              itemBuilder: (context, index) {
                final musica = musicas[index];
                return ListTile(
                  title: Text(musica["titulo"]!),
                  trailing: const Icon(Icons.music_note, color: Color(0xFFE5A93C)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VisualizadorCifraPage(
                          nomeMusica: musica["titulo"]!,
                          arquivoCifra: musica["arquivo"]!,
                          arquivoAudio: "", // Adicionar caminho do áudio futuramente
                          // Passamos o texto direto se a música veio da web, senão o visualizador lê o arquivo txt
                          conteudoDireto: musica["conteudoDireto"], 
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