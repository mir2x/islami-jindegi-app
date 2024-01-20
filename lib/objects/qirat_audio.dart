import 'package:equatable/equatable.dart';

class QiratAudio extends Equatable {
  const QiratAudio({
    required this.audioPath,
    required this.surah,
    required this.ayah,
  });

  final String audioPath;
  final String surah;
  final String ayah;

  @override
  List<Object> get props => [audioPath, surah, ayah];
}
