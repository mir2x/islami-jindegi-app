import 'dart:async';
import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class RetainedListKey {
  const RetainedListKey(this.params);
  final Map<String, dynamic> params;
  @override
  bool operator ==(Object other) =>
      other is RetainedListKey &&
      const MapEquality<String, dynamic>().equals(params, other.params);
  @override
  int get hashCode => const MapEquality<String, dynamic>().hash(params);
}

class RetainedListState<T> {
  RetainedListState(
      {required int pageSize, required Future<List<T>> Function(int) fetch})
      : controller = PagingController<int, T>(
          getNextPageKey: (state) {
            final pages = state.pages;
            if (pages == null || pages.isEmpty) return 1;
            return pages.last.length < pageSize
                ? null
                : (state.keys?.last ?? 0) + 1;
          },
          fetchPage: fetch,
        ) {
    scrollController.addListener(_save);
  }
  final PagingController<int, T> controller;
  final ScrollController scrollController = ScrollController();
  double _offset = 0;
  Timer? _timer;
  void _save() {
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 150), () {
      if (scrollController.hasClients) _offset = scrollController.offset;
    });
  }

  void restore() {
    if (scrollController.hasClients && _offset != 0)
      scrollController.jumpTo(_offset
          .clamp(0, scrollController.position.maxScrollExtent)
          .toDouble());
  }

  void dispose() {
    _timer?.cancel();
    controller.dispose();
    scrollController.dispose();
  }
}

class RetainedListRegistry {
  final _links = LinkedHashMap<Object, void Function()>();
  void retain(Object key, dynamic link) {
    _links.remove(key)?.call();
    _links[key] = () => link.close();
    while (_links.length > 3) {
      _links.remove(_links.keys.first)?.call();
    }
  }

  void remove(Object key) => _links.remove(key);
}
