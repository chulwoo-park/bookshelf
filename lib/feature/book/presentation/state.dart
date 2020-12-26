import 'package:bookshelf/common/model/state.dart';
import 'package:bookshelf/feature/book/domain/model.dart';
import 'package:flutter/foundation.dart';

enum BookListLoadMoreState {
  idle,
  loading,
  failure,
  reachedEnd,
}

class BookListLoaded extends AsyncState {
  const BookListLoaded(
    this.items, {
    @required this.query,
    @required this.totalCount,
    this.page = 1,
    this.loadMoreState = BookListLoadMoreState.idle,
  });

  final String query;
  final int totalCount;
  final int page;
  final List<Book> items;
  final BookListLoadMoreState loadMoreState;

  @override
  int get hashCode {
    return 31 +
        items.hashCode +
        query.hashCode +
        page.hashCode +
        loadMoreState.hashCode;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is BookListLoaded &&
            listEquals(items, other.items) &&
            query == other.query &&
            page == other.page &&
            loadMoreState == other.loadMoreState);
  }

  BookListLoaded copyWith({
    List<Book> data,
    int page,
    BookListLoadMoreState loadMoreState,
  }) {
    return BookListLoaded(
      data ?? this.items,
      query: this.query,
      totalCount: this.totalCount,
      page: page ?? this.page,
      loadMoreState: loadMoreState ?? this.loadMoreState,
    );
  }

  @override
  String toString() {
    return '{data: $items, query: $query, page: $page, loadMoreState: $loadMoreState}';
  }
}
