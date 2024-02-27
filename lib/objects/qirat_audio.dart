import 'package:equatable/equatable.dart';

class QiratAudio extends Equatable {
  const QiratAudio({
    required this.surah,
    required this.ayah,
    required this.audioPath,
    this.nextAudioPath,
    this.autoPlay = false,
  });

  final String surah;
  final String ayah;
  final String audioPath;
  final String? nextAudioPath;
  final bool autoPlay;

  @override
  List<dynamic> get props => [surah, ayah, audioPath, nextAudioPath, autoPlay];
}
