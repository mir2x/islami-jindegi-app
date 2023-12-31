import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';

class QiratPlayerAudio extends Equatable {
  const QiratPlayerAudio({
    required this.player,
    required this.audioPath,
  });

  final AudioPlayer player;
  final String audioPath;

  @override
  List<Object> get props => [player, audioPath];
}
