import 'package:equatable/equatable.dart';

class SingleModelQuery extends Equatable {
  const SingleModelQuery({
    required this.repository,
    required this.id,
    this.remote = false,
  });

  final String repository;
  final String id;
  final bool remote;

  @override
  List<Object> get props => [repository, id, remote];
}
