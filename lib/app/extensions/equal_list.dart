import 'dart:collection';

import 'package:collection/collection.dart';

const _equality = ListEquality();

class EqualList<T> extends ListBase<T> {
  final List<T> inner;

  EqualList(this.inner);

  @override
  int get length => inner.length;

  @override
  set length(int value) => inner.length = value;

  @override
  T operator [](int index) => inner[index];

  @override
  void operator []=(int index, T value) => inner[index] = value;

  @override
  int get hashCode => _equality.hash(this);

  @override
  bool operator ==(Object other) {
    return other is List<T> && _equality.equals(other, this);
  }
}
