import 'package:flutter/services.dart';

class CifraParser {
  // Lê o arquivo .txt da pasta assets
  static Future<String> carregarCifra(String nomeArquivo) async {
    try {
      return await rootBundle.loadString('assets/cifras/$nomeArquivo');
    } catch (e) {
      return "Erro ao carregar a cifra: $e";
    }
  }
}