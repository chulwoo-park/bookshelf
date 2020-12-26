import 'package:bookshelf/feature/book/domain/model.dart';
import 'package:flutter/foundation.dart';

abstract class BookListState {
  const BookListState();

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  bool operator ==(Object other) => runtimeType == other.runtimeType;
}

class Initial extends BookListState {
  const Initial();
}

class Loading extends BookListState {
  const Loading();
}

class Success extends BookListState {
  const Success(
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
        (other is Success &&
            listEquals(items, other.items) &&
            query == other.query &&
            page == other.page &&
            loadMoreState == other.loadMoreState);
  }

  Success copyWith({
    List<Book> data,
    int page,
    BookListLoadMoreState loadMoreState,
  }) {
    return Success(
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

class Failure implements BookListState {
  const Failure(this.error, [this.stackTrace]);

  final Object error;
  final StackTrace stackTrace;
}

enum BookListLoadMoreState {
  idle,
  loading,
  failure,
  reachedEnd,
}
