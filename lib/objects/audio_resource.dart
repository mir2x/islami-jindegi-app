import 'package:equatable/equatable.dart';

class AudioResource extends Equatable {
  const AudioResource({
    required this.id,
    required this.storage,
  });

  final String id;
  final String storage;

  @override
  List<Object> get props => [id, storage];
}
