import 'dart:convert';
import 'package:flutter_data/flutter_data.dart';
import 'package:native_app/providers/local_database.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
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
    final connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.none) {
      final database = ref.read(localDatabaseProvider);
      final resources = await database.query(internalType, params: params);

      final body = resources.map((m) {
        var resourceMap = json.decode(m.toJsonString());

        final id = resourceMap.remove('id');

        // attributes
        Map<String, dynamic> attributes = Map.from(resourceMap);

        // assemble type, id, attributes, relationships in `Resource`
        final resource = Resource(internalType, id.toString());
        resource.attributes.addAll(attributes);
        /* resource.relationships.addAll(relationships); */
        return resource;
      });

      final outbound = OutboundDataDocument.collection(body).toJson();

      // run decode/encode because `json_api`'s `toJson()`
      // DOES NOT return nested Map<String, dynamic>s as expected
      var response = json.decode(json.encode(outbound)) as Map<String, dynamic>;

      final deserialized = await deserialize(response);
      return deserialized.models;
    } else {
      return super.findAll(
        remote: remote,
        background: background,
        params: params,
        headers: headers,
        syncLocal: syncLocal,
        onSuccess: onSuccess,
        onError: onError,
        label: label,
      );
    }
  }

  @override
  Future<T?> findOne(
    Object id, {
    bool? remote,
    bool? background,
    Map<String, dynamic>? params,
    Map<String, String>? headers,
    OnSuccessOne<T>? onSuccess,
    OnErrorOne<T>? onError,
    DataRequestLabel? label,
  }) async {
    final connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.none) {
      final database = ref.read(localDatabaseProvider);
      final resource = await database.findById(internalType, id.toString());

      var resourceMap = json.decode(resource.toJsonString());

      final idValue = resourceMap.remove('id');

      // attributes
      Map<String, dynamic> attributes = Map.from(resourceMap);

      // assemble type, id, attributes, relationships in `Resource`
      final newResource = NewResource(internalType, idValue.toString());
      newResource.attributes.addAll(attributes);
      /* newResource.relationships.addAll(relationships); */

      final outbound = OutboundDataDocument.newResource(newResource).toJson();

      // run decode/encode because `json_api`'s `toJson()`
      // DOES NOT return nested Map<String, dynamic>s as expected
      var response = json.decode(json.encode(outbound)) as Map<String, dynamic>;

      final deserialized = await deserialize(response);
      return deserialized.model;
    } else {
      return super.findOne(
        id,
        remote: remote,
        background: background,
        params: params,
        headers: headers,
        onSuccess: onSuccess,
        onError: onError,
        label: label,
      );
    }
  }
}
