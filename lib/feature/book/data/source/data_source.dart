import 'package:bookshelf/feature/book/domain/model/book.dart';

abstract class LocalBookSource {
  Future<List<Book>> find(String query, {int page = 1});

  void save({String query, int page, List<Book> data});
}

abstract class RemoteBookSource {
  Future<List<Book>> find(String query, {int page = 1});
}
