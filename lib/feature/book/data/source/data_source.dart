import 'package:bookshelf/feature/book/domain/model/book.dart';

abstract class LocalBookSource {
  find(String query) {}

  save({String query, int page, List<Book> data}) {}
}

abstract class RemoteBookSource {
  find(String query) {}
}
