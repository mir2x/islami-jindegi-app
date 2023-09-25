import 'package:equatable/equatable.dart';

class PdfSource extends Equatable {
  const PdfSource({
    required this.resourceId,
    required this.document,
  });

  final String resourceId;
  final Map document;

  @override
  List<Object> get props => [resourceId, document];
}
