import 'package:equatable/equatable.dart';

class AudioSource extends Equatable {
  const AudioSource({
    required this.id,
    required this.storage,
  });

  final String id;
  final String storage;

  @override
  List<Object> get props => [id, storage];
}
