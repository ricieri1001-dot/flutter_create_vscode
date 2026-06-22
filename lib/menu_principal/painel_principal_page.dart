import 'package:flutter/material.dart';

class PainelPrincipalPage extends StatefulWidget {
  // Adicionamos um gatilho que recebe o índice da aba para onde queremos navegar
  final Function(int) onMudarAba;

  const PainelPrincipalPage({
    super.key,
    required this.onMudarAba,
  });

  @override
  State<PainelPrincipalPage> createState() => _PainelPrincipalPageState();
}

class _PainelPrincipalPageState extends State<PainelPrincipalPage> {
  final TextEditingController _buscaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [
              Color(0xFF0F1E36), // Azul petróleo sutil no centro
              Color(0xFF050B14), // Preto azulado profundo nas bordas
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==========================================
                // CABEÇALHO: Logótipo e Perfil
                // ==========================================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.audiotrack, color: Color(0xFFE5A93C), size: 32),
                        const SizedBox(width: 8),
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                              height: 1.1,
                              letterSpacing: 0.8,
                              color: Colors.white,
                            ),
                            children: [
                              TextSpan(text: "CENTRAL\n"),
                              TextSpan(
                                text: "DO MÚSICO",
                                style: TextStyle(color: Color(0xFFE5A93C)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const CircleAvatar(
                      radius: 22,
                      backgroundColor: Color(0xFF1E293B),
                      child: Icon(Icons.person, color: Colors.white70, size: 24),
                    )
                  ],
                ),
                const SizedBox(height: 28),

                // Saudação personalizada
                const Text(
                  "Boa noite, Ericson! 👋",
                  style: TextStyle(
                    fontSize: 24, 
                    fontWeight: FontWeight.w900, 
                    color: Colors.white,
                  ),
                ),
                const Text(
                  "Pronto para fazer música?",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 24),

                // ==========================================
                // BARRA DE PESQUISA ESTILIZADA
                // ==========================================
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF111A2E),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: TextField(
                    controller: _buscaController,
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Buscar música, artista ou cifra...",
                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 22),
                      suffixIcon: const Icon(Icons.mic, color: Colors.grey, size: 22),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                const Text(
                  "Acesso rápido",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 16),

                // ==========================================
                // CARD PREMIUM: LETRA E CIFRA (CONECTADO)
                // ==========================================
                GestureDetector(
                  onTap: () {
                    // Aba 1: Abre o módulo de Repertório / Cifras
                    widget.onMudarAba(1); 
                  },
                  child: Container(
                    width: double.infinity,
                    height: 260,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white10),
                      color: const Color(0xFF111A2E),
                      image: const DecorationImage(
                        image: NetworkImage('https://images.unsplash.com/photo-1510915361894-db8b60106cb1?q=80&w=600&auto=format&fit=crop'),
                        fit: BoxFit.cover,
                        opacity: 0.18,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1E293B),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.music_note, color: Color(0xFFE5A93C), size: 28),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "LETRA E CIFRA",
                                style: TextStyle(
                                  fontWeight: FontWeight.black, 
                                  fontSize: 18, 
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                "Encontre a cifra da sua música favorita.",
                                style: TextStyle(fontSize: 13, color: Colors.grey),
                              ),
                            ],
                          ),

                          Row(
                            children: [
                              _buildCircleShortcut(Icons.star_border, "Favoritos"),
                              const SizedBox(width: 12),
                              _buildCircleShortcut(Icons.history, "Histórico"),
                              const SizedBox(width: 12),
                              _buildCircleShortcut(Icons.text_fields, "Tom"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Indicador de Paginação
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildPageDot(isActive: true),
                    _buildPageDot(isActive: false),
                    _buildPageDot(isActive: false),
                    _buildPageDot(isActive: false),
                    _buildPageDot(isActive: false),
                  ],
                ),
                const SizedBox(height: 28),

                // ==========================================
                // MIXER COMPACTO: ÚLTIMA COMPOSIÇÃO (CONECTADO)
                // ==========================================
                GestureDetector(
                  onTap: () {
                    // Aba 2: Salta direto para a mesa de som Multipistas
                    widget.onMudarAba(2);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFF111A2E),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.bolt, color: Color(0xFFE5A93C), size: 24),
                                const SizedBox(width: 8),
                                Text(
                                  "ÚLTIMA COMPOSIÇÃO",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold, 
                                    fontSize: 14, 
                                    color: Colors.white.withOpacity(0.9),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                            const Icon(Icons.more_vert, color: Colors.grey, size: 22),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Toque aqui para abrir o Console Mixer Multipistas.",
                          style: TextStyle(fontSize: 13, color: Colors.grey, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCircleShortcut(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFE5A93C), size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildPageDot({required bool isActive}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      height: 6,
      width: isActive ? 18 : 6,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFE5A93C) : Colors.white24,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }
}