import 'package:bookshelf/common/exception/exceptions.dart';
import 'package:bookshelf/common/model/page.dart';
import 'package:bookshelf/feature/book/domain/model.dart';

abstract class LocalBookSource {
  /// Returns the data for the given [key] or throws [CacheMissException] if
  /// [key] is not in the local source.
  Future<Page<Book>> getList(String key);

  /// Save [data] by [key].
  Future<void> saveList(String key, Page<Book> data);

  Future<BookDetail> getDetail(String isbn13);

  Future<void> saveDetail(String isbn13, BookDetail detail);
}

abstract class RemoteBookSource {
  /// {@macro find_book}
  Future<Page<Book>> find(String query, {int page = 1});

  Future<BookDetail> getDetail(String isbn13);
}
