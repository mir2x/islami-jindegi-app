import 'package:equatable/equatable.dart';

class AllModelsQuery extends Equatable {
  const AllModelsQuery({
    required this.repository,
    this.params = const {},
    this.syncLocal = true,
  });

  final String repository;
  final Map<String, dynamic> params;
  final bool syncLocal;

  @override
  List<Object> get props => [repository, params, syncLocal];
}
