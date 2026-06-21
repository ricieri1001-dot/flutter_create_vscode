import 'package:flutter/material.dart';
import '../main.dart';

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MEU PERFIL 👤', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        backgroundColor: const Color(0xFF0E1622),
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Center(
            child: CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.primary,
              child: Icon(Icons.person, size: 50, color: Colors.black),
            ),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text('Olá, Maestro!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 32),
          _buildOpcaoMenu(Icons.settings, 'Configurações do App'),
          _buildOpcaoMenu(Icons.folder_open, 'Backup de Repertório'),
          _buildOpcaoMenu(Icons.info_outline, 'Sobre o App'),
          const SizedBox(height: 40),
          TextButton(
            onPressed: () {},
            child: const Text('Sair da Conta', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildOpcaoMenu(IconData icon, String titulo) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: const Color(0xFF0E1622), borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(titulo, style: const TextStyle(fontSize: 14)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () {},
      ),
    );
  }
}