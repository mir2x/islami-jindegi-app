import 'dart:convert';
import 'package:flutter_data/flutter_data.dart' hide Relationship;
import 'package:json_api/document.dart';
import 'package:recase/recase.dart';
import 'package:native_app/providers/local_location.dart';

mixin LocalLocationAdapter<T extends DataModel<T>> on RemoteAdapter<T> {
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
    final localLocation = ref.read(localLocationProvider);
    final resources = await localLocation.query(internalType, params: params);
    List<Resource> included = [];

    final body = resources.map((item) {
      Map resourceMap;
      Map<String, Relationship> relationships = {};

      resourceMap = json.decode(json.encode(item));
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

    List<T> items = await this.onSuccess(data, label);

    return items;
  }

  Resource mapToResource(Map resourceMap, String type) {
    final id = resourceMap.remove('id');

    // attributes
    Map<String, Object?> attributes = resourceMap.map<String, Object?>(
      (k, v) => MapEntry<String, Object?>(ReCase(k).paramCase, v),
    );

    final resource = Resource(ReCase(type).snakeCase, id.toString());
    resource.attributes.addAll(attributes);
    return resource;
  }
}
