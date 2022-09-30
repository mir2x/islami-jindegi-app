import 'package:flutter_dotenv/flutter_dotenv.dart';

String audioSrc(audio) {
  return "${dotenv.env['STATIC_HOST_NAME']}/uploads/${audio['storage']}/${audio['id']}";
}
