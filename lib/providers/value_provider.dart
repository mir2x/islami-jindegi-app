import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Generic settable state holder — the riverpod 3 replacement for the
/// deprecated `StateProvider`. Read the current value with `ref.watch(p)`
/// (or `ref.read(p.notifier).value`); mutate it with
/// `ref.read(p.notifier).set(x)` or `.update((v) => ...)`.
class ValueController<T> extends Notifier<T> {
  ValueController(this._initial);
  final T _initial;

  @override
  T build() => _initial;

  T get value => state;

  void set(T value) => state = value;

  void update(T Function(T current) cb) => state = cb(state);
}

NotifierProvider<ValueController<T>, T> valueProvider<T>(T initial) {
  return NotifierProvider<ValueController<T>, T>(
    () => ValueController<T>(initial),
  );
}
