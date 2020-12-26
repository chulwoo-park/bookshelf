abstract class BookListEvent {}

class BookSearched implements BookListEvent {
  const BookSearched(this.query);

  final String query;
}

class NextPageRequested implements BookListEvent {
  const NextPageRequested();
}

abstract class BookDetailEvent {}

class BookDetailRequested implements BookDetailEvent {
  const BookDetailRequested(this.isbn13);

  final String isbn13;
}
