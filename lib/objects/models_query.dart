import 'package:equatable/equatable.dart';

class ModelsQuery extends Equatable {
  const ModelsQuery({
    required this.model,
    this.params = const {},
    this.syncLocal = false,
  });

  final String model;
  final Map<String, dynamic> params;
  final bool syncLocal;

  @override
  List<Object> get props => [model, params, syncLocal];
}
