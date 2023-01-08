import 'package:equatable/equatable.dart';
import 'package:flutter_data/flutter_data.dart';

class SingleModelQuery extends Equatable {
  const SingleModelQuery({
    required this.repository,
    required this.id,
    this.remote = false,
  });

  final Repository repository;
  final String id;
  final bool remote;

  @override
  List<Object> get props => [repository, id, remote];
}
