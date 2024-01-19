import 'package:equatable/equatable.dart';

class AudioResource extends Equatable {
  const AudioResource({
    required this.id,
    required this.storage,
    required this.album,
    required this.title,
  });

  final String id;
  final String storage;
  final String album;
  final String title;

  @override
  List<Object> get props => [id, storage, album, title];
}
