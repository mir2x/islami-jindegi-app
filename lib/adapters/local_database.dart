import 'dart:convert';
import 'package:flutter_data/flutter_data.dart' hide Relationship;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:json_api/document.dart';
import 'package:recase/recase.dart';
import 'package:native_app/providers/local_database.dart';

mixin LocalDatabaseAdapter<T extends DataModel<T>> on RemoteAdapter<T> {
  @override
  Future<List<T>> findAll({
    bool? remote,
    bool? background,
    Map<String, dynamic>? params,
    Map<String, String>? headers,
    bool? syncLocal,
    OnSuccessAll<T>? onSuccess,
    OnErrorAll<T>? onError,
    DataRequestLabel? label,
  }) async {
    bool onlyLocal =
        params != null && params.containsKey('offline') && params['offline'];

    bool hasOneItem = params != null &&
        params.containsKey('quantity') &&
        params['quantity'] == 1;

    bool hasNoConnection =
        await Connectivity().checkConnectivity() == ConnectivityResult.none;

    if (onlyLocal || hasOneItem || hasNoConnection) {
      final database = ref.read(localDatabaseProvider);
      final resources = await database.query(internalType, params: params);
      List<Resource> included = [];

      final body = resources.map((item) {
        Map resourceMap;
        Map<String, Relationship> relationships = {};

        if (item is Map) {
          resourceMap = json.decode(json.encode(item[internalType]));

          for (final relEntry in item['relationships'].entries) {
            final key = relEntry.key;
            final value = relEntry.value;

            if (value is Iterable) {
              final identifiers = value.map((subitem) {
                return Identifier(key, subitem.id.toString());
              }).toList();
              relationships[key] = ToMany(identifiers);

              for (final subitem in value) {
                var includedResourceMap = json.decode(json.encode(subitem));
                included.add(mapToResource(includedResourceMap, key));
              }
            } else if (value != null) {
              relationships[key] = ToOne(Identifier(key, value.id.toString()));
              var includedResourceMap = json.decode(json.encode(value));
              included.add(mapToResource(includedResourceMap, key));
            }
          }
        } else {
          resourceMap = json.decode(json.encode(item));
        }

        Resource resource = mapToResource(resourceMap, internalType);
        resource.relationships.addAll(relationships);
        return resource;
      });

      var outboundData = OutboundDataDocument.collection(body);
      outboundData.included.addAll(included);

      var outbound = outboundData.toJson();

      // run decode/encode because `json_api`'s `toJson()`
      // DOES NOT return nested Map<String, dynamic>s as expected
      var jData = json.decode(json.encode(outbound)) as Map<String, dynamic>;
      label ??= DataRequestLabel('findAll', type: internalType);

      final data = DataResponse(
        body: jData,
        statusCode: 200,
        headers: {'content-type': 'application/vnd.api+json'},
      );

      onSuccess ??= (data, label, _) => this.onSuccess<List<T>>(data, label);

      List<T> items = await onSuccess.call(data, label, this) ?? <T>[];

      if (items.isNotEmpty || onlyLocal || hasNoConnection) {
        return items;
      }
    }

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
    final database = ref.read(localDatabaseProvider);
    final item = await database.findById(
      internalType,
      id.toString(),
      params: params,
    );

    if (item != null) {
      Map resourceMap;
      Map<String, Relationship> relationships = {};
      List<Resource> included = [];

      if (item is Map) {
        resourceMap = json.decode(json.encode(item[internalType]));

        for (final relEntry in item['relationships'].entries) {
          final key = relEntry.key;
          final value = relEntry.value;

          if (value is Iterable) {
            final identifiers = value.map((subitem) {
              return Identifier(key, subitem.id.toString());
            }).toList();
            relationships[key] = ToMany(identifiers);

            for (final subitem in value) {
              var includedResourceMap = json.decode(json.encode(subitem));
              included.add(mapToResource(includedResourceMap, key));
            }
          } else if (value != null) {
            relationships[key] = ToOne(Identifier(key, value.id.toString()));
            var includedResourceMap = json.decode(json.encode(value));
            included.add(mapToResource(includedResourceMap, key));
          }
        }
      } else {
        resourceMap = json.decode(json.encode(item));
      }

      Resource resource = mapToResource(resourceMap, internalType);
      resource.relationships.addAll(relationships);

      final outboundData = OutboundDataDocument.resource(resource);
      outboundData.included.addAll(included);

      var outbound = outboundData.toJson();

      // run decode/encode because `json_api`'s `toJson()`
      // DOES NOT return nested Map<String, dynamic>s as expected
      var jData = json.decode(json.encode(outbound)) as Map<String, dynamic>;
      label ??= DataRequestLabel('findOne', type: internalType);

      final data = DataResponse(
        body: jData,
        statusCode: 200,
        headers: {'content-type': 'application/vnd.api+json'},
      );

      onSuccess ??= (data, label, _) => this.onSuccess<T>(data, label);
      return onSuccess.call(data, label, this);
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

  Resource mapToResource(Map resourceMap, String type) {
    final id = resourceMap.remove('id');

    // attributes
    Map<String, Object?> attributes = resourceMap.map<String, Object?>(
      (k, v) => MapEntry<String, Object?>(ReCase(k).paramCase, v),
    );

    final resource = Resource(type, id.toString());
    resource.attributes.addAll(attributes);
    return resource;
  }
}
