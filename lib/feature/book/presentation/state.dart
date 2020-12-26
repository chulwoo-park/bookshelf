import 'package:bookshelf/feature/book/domain/model.dart';

abstract class BookListState {}

class Initial implements BookListState {}

class Loading implements BookListState {}

class Success implements BookListState {
  const Success(this.data, this.loadMoreState);

  final List<Book> data;
  final BookListLoadMoreState loadMoreState;
}

class Failure implements BookListState {}

enum BookListLoadMoreState {
  idle,
  loading,
  failure,
  reachedEnd,
}
