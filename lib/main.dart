import 'dart:async';
import 'package:flutter/material.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'menu_principal/painel_principal_page.dart';
import 'mixer/mixer_page.dart';
import 'repertorio/lista_repertorio_page.dart';
import 'ferramentas/ferramentas_page.dart';
import 'perfil/perfil_page.dart'; 

void main() => runApp(const CentralDoMusicoApp());

// BASE DE IDENTIDADE VISUAL (INTOCÁVEL)
class AppColors {
  static const Color background = Color(0xFF070B11);
  static const Color surface = Color(0xFF0E1622);
  static const Color cardBg = Color(0xFF131D2C);
  static const Color primary = Color(0xFFE5A93C);
  static const Color textCifra = Color(0xFF74E9A7);
}

class CentralDoMusicoApp extends StatelessWidget {
  const CentralDoMusicoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Central do Músico Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primary,
        colorScheme: const ColorScheme.dark(primary: AppColors.primary, surface: AppColors.surface),
      ),
      home: const BaseNavigationWindow(),
    );
  }
}

class BaseNavigationWindow extends StatefulWidget {
  const BaseNavigationWindow({super.key});

  @override
  State<BaseNavigationWindow> createState() => _BaseNavigationWindowState();
}

class _BaseNavigationWindowState extends State<BaseNavigationWindow> {
  int _currentTab = 0; 
  late StreamSubscription _intentDataStreamSubscription;
  late List<Widget> _paginas;

  // CHAVE MANTIDA PARA A FUNCIONALIDADE DE IMPORTAÇÃO
  final GlobalKey<ListaRepertorioPageState> _repertorioKey = GlobalKey<ListaRepertorioPageState>();

  @override
  void initState() {
    super.initState();
    // BASE DE PÁGINAS E NAVEGAÇÃO COMPLETA (INCLUINDO PERFIL)
    _paginas = [
      PainelPrincipalPage(onMudarAba: _mudarAba), 
      ListaRepertorioPage(key: _repertorioKey),        
      const MixerPage(),
      const FerramentasPage(),
      const PerfilPage(),
    ];

    _intentDataStreamSubscription = ReceiveSharingIntent.instance.getMediaStream().listen((value) {
      if (value.isNotEmpty) _tratarLinkCompartilhado(value.first.path);
    });

    ReceiveSharingIntent.instance.getInitialMedia().then((value) {
      if (value.isNotEmpty) _tratarLinkCompartilhado(value.first.path);
    });
  }

  // FUNCIONALIDADE DE IMPORTAÇÃO (ANEXO AO CÓDIGO)
  Future<Map<String, String>> _extrairCifraDoSite(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var document = parser.parse(response.body);
        var tituloElemento = document.getElementsByTagName('title');
        String tituloMusica = tituloElemento.isNotEmpty ? tituloElemento.first.text.split(" - ").first.trim() : "Cifra Importada";
        var elementos = document.getElementsByTagName('pre');
        String textoExtraido = elementos.isNotEmpty ? elementos.first.text : "Não foi possível extrair a cifra automaticamente.";
        return {"titulo": tituloMusica, "cifra": textoExtraido};
      }
      return {"titulo": "Erro", "cifra": "Erro de conexão: ${response.statusCode}"};
    } catch (e) {
      return {"titulo": "Erro", "cifra": "Erro na extração: $e"};
    }
  }

  void _tratarLinkCompartilhado(String url) async {
    if (!url.contains("http")) return;
    final String urlLimpa = url.split(" ").firstWhere((e) => e.startsWith("http"), orElse: () => url);

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Capturando cifra da Web...")));

    Map<String, String> dadosMusica = await _extrairCifraDoSite(urlLimpa);
    
    if (_repertorioKey.currentState != null) {
      _repertorioKey.currentState!.adicionarMusicaImportada(dadosMusica["titulo"]!, dadosMusica["cifra"]!);
    }
    _mudarAba(1);
  }

  void _mudarAba(int index) => setState(() => _currentTab = index);

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ESTRUTURA BASE DA NAVEGAÇÃO INALTERADA
    return Scaffold(
      body: IndexedStack(index: _currentTab, children: _paginas),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTab,
        onTap: _mudarAba,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF0A0F18),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.queue_music), label: 'Repertório'),
          BottomNavigationBarItem(icon: Icon(Icons.tune), label: 'Mixer'),
          BottomNavigationBarItem(icon: Icon(Icons.build_circle_outlined), label: 'Ferramentas'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Perfil'),
        ],
      ),
    );
  }
}