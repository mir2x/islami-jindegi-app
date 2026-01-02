import 'package:equatable/equatable.dart';
import 'package:flutter_data/flutter_data.dart';

class AllModelsQuery extends Equatable {
  const AllModelsQuery({
    required this.repository,
    this.params = const {},
    this.syncLocal = false,
  });

  final Repository repository;
  final Map<String, dynamic> params;
  final bool syncLocal;

  // Use repository.runtimeType.toString() instead of the repository instance
  // to prevent equality issues when repository references change
  @override
  List<Object> get props =>
      [repository.runtimeType.toString(), params, syncLocal];
}
