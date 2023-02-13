import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/local_server/db/local_database.dart';

final localDatabaseProvider = Provider((ref) => LocalDatabase());
