import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/local_server/resource/local_resource_api.dart';

final localResourceProvider = Provider((ref) => LocalResourceAPI());
