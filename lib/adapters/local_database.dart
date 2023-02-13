import 'package:flutter_data/flutter_data.dart';
import 'package:native_app/providers/local_database.dart';
import 'dart:convert';
import 'package:json_api/document.dart';

mixin LocalDatabaseAdapter<T extends DataModel<T>> on RemoteAdapter<T> {
  @override
  Future<List<T>?> findAll({
    bool? remote,
    bool? background,
    Map<String, dynamic>? params,
    Map<String, String>? headers,
    bool? syncLocal,
    OnSuccessAll<T>? onSuccess,
    OnErrorAll<T>? onError,
    DataRequestLabel? label,
  }) async {
      final database = ref.read(localDatabaseProvider);
      final allMasails = await database.select(database.masails).get();

      final body = allMasails.map((m) {
        var resource = json.decode(m.toJsonString());

        final id = resource.remove('id');

        // attributes
        Map<String, dynamic> attributes = Map.fromEntries(
          resource.entries,
        );

        // assemble type, id, attributes, relationships in `Resource`
        final newResource = Resource(internalType, id.toString());
        newResource.attributes.addAll(attributes);
        /* newResource.relationships.addAll(relationships); */
        return newResource;
      });

      final outbound = OutboundDataDocument.collection(body).toJson();

      // run decode/encode because `json_api`'s `toJson()`
      // DOES NOT return nested Map<String, dynamic>s as expected
      var response = json.decode(json.encode(outbound)) as Map<String, dynamic>;

      final deserialized = await deserialize(response);
      return deserialized.models;
  }
}
