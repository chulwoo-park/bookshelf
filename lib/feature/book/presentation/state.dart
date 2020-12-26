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
    this.data, {
    @required this.query,
    this.page = 1,
    this.loadMoreState = BookListLoadMoreState.idle,
  });

  final String query;
  final int page;
  final List<Book> data;
  final BookListLoadMoreState loadMoreState;

  @override
  int get hashCode {
    return 31 +
        data.hashCode +
        query.hashCode +
        page.hashCode +
        loadMoreState.hashCode;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Success &&
            listEquals(data, other.data) &&
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
      data ?? this.data,
      query: this.query,
      page: page ?? this.page,
      loadMoreState: loadMoreState ?? this.loadMoreState,
    );
  }

  @override
  String toString() {
    return '{data: $data, query: $query, page: $page, loadMoreState: $loadMoreState}';
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
