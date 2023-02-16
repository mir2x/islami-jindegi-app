import 'package:equatable/equatable.dart';
import 'package:flutter_data/flutter_data.dart';

class SingleModelQuery extends Equatable {
  const SingleModelQuery({
    required this.repository,
    required this.id,
    this.params = const {},
    this.remote = true,
  });

  final Repository repository;
  final String id;
  final Map<String, dynamic> params;
  final bool remote;

  @override
  List<Object> get props => [repository, id, params, remote];
}
