import 'package:flutter/material.dart';

class DetalhesAcordePage extends StatelessWidget {
  final String nota;
  final List<dynamic> variacoes;

  const DetalhesAcordePage({super.key, required this.nota, required this.variacoes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Acorde de $nota')),
      body: ListView.builder(
        itemCount: variacoes.length,
        itemBuilder: (context, index) {
          final v = variacoes[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text('${v['tipo']}'),
              subtitle: Text('Posição: ${v['posicao']}'),
            ),
          );
        },
      ),
    );
  }
}