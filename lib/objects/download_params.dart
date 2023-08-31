import 'package:equatable/equatable.dart';
import 'package:native_app/objects/progress_percentage.dart';

class DownloadParams extends Equatable {
  const DownloadParams({
    required this.url,
    required this.savePath,
    required this.downloadProgress,
  });

  final String url;
  final String savePath;
  final ProgressPercentage downloadProgress;

  @override
  List<Object> get props => [url, savePath, downloadProgress];
}
