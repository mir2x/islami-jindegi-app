import 'package:equatable/equatable.dart';
import 'package:flutter_data/flutter_data.dart';

class AllModelsQuery extends Equatable {
  const AllModelsQuery({
    required this.repository,
    this.params = const {},
    this.syncLocal = true,
  });

  final Repository repository;
  final Map<String, dynamic> params;
  final bool syncLocal;

  @override
  List<Object> get props => [repository, params, syncLocal];
}
