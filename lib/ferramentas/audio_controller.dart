import 'package:just_audio/just_audio.dart';

class AudioController {
  final AudioPlayer _player = AudioPlayer();

  // Stream que nos avisa quando a música termina
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  Future<void> carregarAudio(String url) async {
    await _player.setUrl(url);
  }

  Future<void> tocar() async {
    await _player.play();
  }

  Future<void> pausar() async {
    await _player.pause();
  }

  // Monitora o fim da música
  void configurarEventoDeFim(Function aoTerminar) {
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        aoTerminar(); // Aqui chamamos a função para pular para a próxima
      }
    });
  }

  void dispose() {
    _player.dispose();
  }
}