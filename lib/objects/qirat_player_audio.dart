import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';

class QiratPlayerAudio extends Equatable {
  const QiratPlayerAudio({
    required this.player,
    required this.audioPath,
    required this.surah,
    required this.ayah,
  });

  final AudioPlayer player;
  final String audioPath;
  final String surah;
  final String ayah;

  @override
  List<Object> get props => [player, audioPath, surah, ayah];
}
