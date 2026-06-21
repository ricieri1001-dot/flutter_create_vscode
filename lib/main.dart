import 'package:flutter/material.dart';
import 'menu_principal/painel_principal_page.dart';
import 'mixer/mixer_page.dart';
import 'repertorio/lista_repertorio_page.dart'; // Importação corrigida
import 'ferramentas/ferramentas_page.dart';
import 'perfil/perfil_page.dart'; 

void main() => runApp(const CentralDoMusicoApp());

// ==========================================
// PALETA DE CORES (Premium e Fiel ao Design)
// ==========================================
class AppColors {
  static const Color background = Color(0xFF070B11);
  static const Color surface = Color(0xFF0E1622);
  static const Color cardBg = Color(0xFF131D2C);
  static const Color primary = Color(0xFFE5A93C);
  static const Color textCifra = Color(0xFF74E9A7);

  static const Color faderVoz = Colors.purpleAccent;
  static const Color faderViolao = Colors.orangeAccent;
  static const Color faderCavaco = Colors.yellowAccent;
  static const Color faderBaixo = Colors.blueAccent;
  static const Color faderPercussao = Colors.greenAccent;
  static const Color faderBateria = Colors.redAccent;
}

// ==========================================
// MODELOS DE DADOS CORE
// ==========================================
class Musica {
  final String id;
  final String titulo;
  final String artista;
  final String cifra;

  const Musica({
    required this.id,
    required this.titulo,
    required this.artista,
    required this.cifra,
  });
}

// ==========================================
// CONFIGURAÇÃO CORE DO APLICATIVO
// ==========================================
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
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          surface: AppColors.surface,
        ),
      ),
      home: const BaseNavigationWindow(),
    );
  }
}

// ==========================================
// CRONOGRAMA DE NAVEGAÇÃO (Espinha Dorsal)
// ==========================================
class BaseNavigationWindow extends StatefulWidget {
  const BaseNavigationWindow({super.key});

  @override
  State<BaseNavigationWindow> createState() => _BaseNavigationWindowState();
}

class _BaseNavigationWindowState extends State<BaseNavigationWindow> {
  int _currentTab = 0; 

  // A lista foi atualizada para chamar o ListaRepertorioPage na posição 1
  final List<Widget> _paginas = [
    const PainelPrincipalPage(), 
    ListaRepertorioPage(),         // <--- Lista carregada aqui
    const MixerPage(),
    const FerramentasPage(),
    const Center(child: Text("Perfil do Músico - Em breve na pasta /perfil/")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentTab, children: _paginas),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTab,
        onTap: (index) => setState(() => _currentTab = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF0A0F18),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.queue_music), label: 'Repertório'),
          BottomNavigationBarItem(icon: Icon(Icons.tune), label: 'Mixer'),
          BottomNavigationBarItem(icon: Icon(Icons.build_circle_outlined), label: 'Ferramentas'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Perfil'),
        ],
      ),
    );
  }
}