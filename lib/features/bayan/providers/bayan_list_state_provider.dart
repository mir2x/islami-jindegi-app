import 'dart:async';
import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:native_app/helpers/date_range_filter.dart';

import '../models/bayan.dart';
import 'bayan_providers.dart';

class BayanListKey {
  const BayanListKey(this.params);
  factory BayanListKey.fromParams(Map<String, dynamic> params) =>
      BayanListKey(Map.unmodifiable(Map<String, dynamic>.from(params)));
  final Map<String, dynamic> params;
  @override
  bool operator ==(Object other) =>
      other is BayanListKey &&
      const MapEquality<String, dynamic>().equals(params, other.params);
  @override
  int get hashCode => const MapEquality<String, dynamic>().hash(params);
}

class BayanListState {
  BayanListState({required Future<List<Bayan>> Function(int) fetchPage})
      : pagingController = PagingController<int, Bayan>(
          getNextPageKey: (state) {
            final pages = state.pages;
            if (pages == null || pages.isEmpty) return 1;
            return pages.last.length < 9 ? null : (state.keys?.last ?? 0) + 1;
          },
          fetchPage: fetchPage,
        ) {
    scrollController.addListener(_saveOffset);
  }
  final PagingController<int, Bayan> pagingController;
  final ScrollController scrollController = ScrollController();
  double _offset = 0;
  Timer? _timer;
  void _saveOffset() {
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 150), () {
      if (scrollController.hasClients) _offset = scrollController.offset;
    });
  }

  void restoreOffset() {
    if (scrollController.hasClients && _offset != 0) {
      scrollController.jumpTo(
        _offset.clamp(0, scrollController.position.maxScrollExtent).toDouble(),
      );
    }
  }

  void dispose() {
    _timer?.cancel();
    if (scrollController.hasClients) _offset = scrollController.offset;
    scrollController.dispose();
    pagingController.dispose();
  }
}

class _Retention {
  final _links = LinkedHashMap<BayanListKey, void Function()>();
  void retain(BayanListKey key, dynamic link) {
    _links.remove(key)?.call();
    _links[key] = () => link.close();
    while (_links.length > 3) _links.remove(_links.keys.first)?.call();
  }

  void remove(BayanListKey key) => _links.remove(key);
}

final _retentionProvider = Provider((_) => _Retention());

final bayanListStateProvider =
    Provider.autoDispose.family<BayanListState, BayanListKey>((ref, key) {
  final api = ref.read(bayanApiServiceProvider);
  final offline = ref.read(bayanOfflineServiceProvider);
  final dates = DateRangeFilter.of(key.params);
  final state = BayanListState(fetchPage: (page) async {
    try {
      return await api.fetchBayans(
        page: page,
        perPage: 9,
        search: key.params['search'],
        speakerId: key.params['speakerId'],
        categoryId: key.params['categoryId'],
        dateFrom: dates.from,
        dateTo: dates.to,
      );
    } catch (_) {
      return offline.queryBayans(
        page: page,
        perPage: 9,
        search: key.params['search'],
        speakerId: key.params['speakerId'],
        categoryId: key.params['categoryId'],
        dateFrom: dates.from,
        dateTo: dates.to,
      );
    }
  });
  final link = ref.keepAlive();
  ref.read(_retentionProvider).retain(key, link);
  ref.onDispose(() {
    ref.read(_retentionProvider).remove(key);
    state.dispose();
  });
  return state;
});
