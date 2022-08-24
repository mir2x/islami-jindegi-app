import 'package:flutter_data/flutter_data.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

mixin ApplicationAdapter<T extends DataModel<T>> on RemoteAdapter<T> {
  @override
  String get baseUrl => '${dotenv.env['API_HOST_NAME']}/api';
}
