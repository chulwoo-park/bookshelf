import 'package:bookshelf/common/exception/exceptions.dart';
import 'package:bookshelf/feature/book/domain/model.dart';

abstract class LocalBookSource {
  /// Returns the data for the given [key] or throws [CacheMissException] if
  /// [key] is not in the local source.
  Future<List<Book>> getList(String key);

  /// Save [data] by [key].
  Future<void> saveList(String key, List<Book> data);
}

abstract class RemoteBookSource {
  /// {@macro find_book}
  Future<List<Book>> find(String query, {int page = 1});
}
