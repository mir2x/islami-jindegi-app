import 'package:equatable/equatable.dart';

class ModelQuery extends Equatable {
  const ModelQuery({
    required this.model,
    required this.id,
    this.remote = false,
  });

  final String model;
  final String id;
  final bool remote;

  @override
  List<Object> get props => [model, id, remote];
}
