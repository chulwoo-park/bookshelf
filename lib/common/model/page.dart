import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class Page<T> with ListMixin<T> implements List<T> {
  const Page({
    @required this.page,
    @required this.totalCount,
    @required List<T> items,
  }) : this._items = items;

  final int page;
  final int totalCount;
  final List<T> _items;

  @override
  int get length => _items.length;

  set length(value) {
    _items.length = value;
  }

  @override
  T operator [](int index) => _items[index];

  @override
  void operator []=(int index, T value) => _items[index] = value;

  @override
  int get hashCode {
    return 31 + page.hashCode + totalCount.hashCode + _items.hashCode;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Page<T> &&
            page == other.page &&
            totalCount == other.totalCount &&
            listEquals(_items, other._items));
  }
}
