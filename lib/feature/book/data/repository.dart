import 'package:bookshelf/common/model/page.dart';
import 'package:bookshelf/feature/book/domain/model.dart';
import 'package:bookshelf/feature/book/domain/repository.dart';

import 'data_source.dart';

class BookRepositoryImpl implements BookRepository {
  const BookRepositoryImpl(this._localSource, this._remoteSource);

  final LocalBookSource _localSource;
  final RemoteBookSource _remoteSource;

  @override
  Future<Page<Book>> find(String query, {int page = 1}) async {
    final cacheKey = '${query}_$page';

    return _localSource
        .getList(cacheKey)
        .catchError((_) => _remoteSource.find(query, page: page).then((result) {
              _localSource.saveList(cacheKey, result);
              return result;
            }));
  }

  @override
  Future<BookDetail> getDetail(String isbn13) {
    return _localSource
        .getDetail(isbn13)
        .catchError((_) => _remoteSource.getDetail(isbn13).then((result) {
              _localSource.saveDetail(isbn13, result);
              return result;
            }));
  }
}
