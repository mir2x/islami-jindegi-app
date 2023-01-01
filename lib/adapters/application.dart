import 'package:flutter_data/flutter_data.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:recase/recase.dart';

mixin ApplicationAdapter<T extends DataModel<T>> on RemoteAdapter<T> {
  @override
  String get baseUrl => '${dotenv.env['API_HOST_NAME']}/api';

  @override
  String get type => ReCase(internalType).snakeCase;
}
