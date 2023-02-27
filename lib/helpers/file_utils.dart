import 'package:flutter_dotenv/flutter_dotenv.dart';

String fileSrcUrl(file) {
  return "${dotenv.env['STATIC_HOST_NAME']}/uploads/${file['storage']}/${file['id']}";
}

String externalAssetUrl(path) {
  return "${dotenv.env['STATIC_HOST_NAME']}/assets/$path";
}
