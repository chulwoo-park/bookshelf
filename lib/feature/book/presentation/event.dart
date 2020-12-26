abstract class BookListEvent {}

class BookSearched implements BookListEvent {
  const BookSearched(this.query);

  final String query;
}

class NextPageRequested implements BookListEvent {
  const NextPageRequested();
}
