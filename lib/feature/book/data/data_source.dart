import 'package:bookshelf/feature/book/domain/model.dart';

abstract class LocalBookSource {
  Future<List<Book>> getList(String key);

  Future<void> saveList(String key, List<Book> data);
}

abstract class RemoteBookSource {
  Future<List<Book>> find(String query, {int page = 1});
}
