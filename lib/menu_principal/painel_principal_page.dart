import 'package:flutter/material.dart';

class PainelPrincipalPage extends StatefulWidget {
  const PainelPrincipalPage({super.key});

  @override
  State<PainelPrincipalPage> createState() => _PainelPrincipalPageState();
}

class _PainelPrincipalPageState extends State<PainelPrincipalPage> {
  final TextEditingController _buscaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==========================================
              // CABEÇALHO: Logótipo e Identificação do Músico
              // ==========================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.audiotrack, color: theme.primaryColor, size: 28),
                          const SizedBox(width: 6),
                          const Text(
                            "CENTRAL\nDO MÚSICO", 
                            style: TextStyle(
                              fontWeight: FontWeight.black, 
                              fontSize: 16, 
                              height: 1.1, 
                              letterSpacing: 0.5
                            )
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Olá, Maestro! 👋", 
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)
                      ),
                      const Text(
                        "Pronto para o próximo concerto?", 
                        style: TextStyle(fontSize: 13, color: Colors.grey)
                      ),
                    ],
                  ),
                  const CircleAvatar(
                    radius: 24,
                    backgroundColor: Color(0xFF0E1622),
                    child: Icon(Icons.person, color: Colors.grey),
                  )
                ],
              ),
              const SizedBox(height: 24),

              // ==========================================
              // DIRETRIZ 4: Barra de Pesquisa Unificada
              // ==========================================
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF0E1622),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _buscaController,
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: "Procurar música, cifras, YouTube, Spotify...",
                    hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.filter_list, color: Colors.grey, size: 20),
                      onPressed: () {
                        // Filtros de busca serão implementados aqui
                      },
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // ==========================================
              // SECÇÃO: Acesso Rápido (Menu de Blocos)
              // ==========================================
              const Text(
                "Acesso rápido", 
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)
              ),
              const SizedBox(height: 14),

              // Grelha de Cartões Principais (Fiel ao design da foto)
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.3,
                children: [
                  _buildMenuCard(
                    icon: Icons.description, 
                    title: "LETRA E CIFRA", 
                    subtitle: "Sincronia completa na internet ou local.", 
                    backgroundColor: const Color(0xFF1E293B),
                    onTap: () {
                      // Rota futura para o módulo de cifras
                    }
                  ),
                  _buildMenuCard(
                    icon: Icons.tune, 
                    title: "PLAYER MIXER", 
                    subtitle: "Controle individual de pistas estilo Moises.", 
                    backgroundColor: const Color(0xFF0F172A),
                    onTap: () {
                      // Rota futura para o mixer
                    }
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ==========================================
              // MIXER COMPACTO (Visual da Home)
              // ==========================================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0E1622),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.play_circle_fill, color: theme.primaryColor, size: 24),
                            const SizedBox(width: 8),
                            const Text(
                              "ÚLTIMA COMPOSIÇÃO", 
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5)
                            ),
                          ],
                        ),
                        const Icon(Icons.more_vert, color: Colors.grey, size: 20),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Nenhuma pista carregada no painel de mixagem.",
                      style: TextStyle(fontSize: 12, color: Colors.grey, style: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required IconData icon, 
    required String title, 
    required String subtitle, 
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFFE5A93C), size: 24),
            const SizedBox(height: 10),
            Text(
              title, 
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 0.5)
            ),
            const SizedBox(height: 4),
            Text(
              subtitle, 
              style: const TextStyle(fontSize: 9, color: Colors.grey), 
              maxLines: 2, 
              overflow: TextOverflow.ellipsis
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }
}
