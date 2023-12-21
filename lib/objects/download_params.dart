import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';
import 'package:native_app/objects/progress_percentage.dart';

class DownloadParams extends Equatable {
  const DownloadParams({
    required this.url,
    required this.savePath,
    this.cancelToken,
    this.downloadProgress,
  });

  final String url;
  final String savePath;
  final CancelToken? cancelToken;
  final ProgressPercentage? downloadProgress;

  @override
  List<dynamic> get props => [url, savePath, cancelToken, downloadProgress];
}
