import 'package:equatable/equatable.dart';

class PdfSource extends Equatable {
  const PdfSource({
    required this.resourceId,
    required this.filePath,
  });

  final String resourceId;
  final String filePath;

  @override
  List<Object> get props => [resourceId, filePath];
}
