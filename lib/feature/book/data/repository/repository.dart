import 'package:bookshelf/feature/book/data/source/data_source.dart';
import 'package:bookshelf/feature/book/domain/model/book.dart';
import 'package:bookshelf/feature/book/domain/repository/repository.dart';

class BookRepositoryImpl implements BookRepository {
  const BookRepositoryImpl(this._localSource, this._remoteSource);

  final LocalBookSource _localSource;
  final RemoteBookSource _remoteSource;

  @override
  Future<List<Book>> find(String query, {int page = 1}) async {
    return _localSource
        .find(query, page: page)
        .catchError((_) => _remoteSource.find(query, page: page).then((result) {
              _localSource.save(query: query, page: page, data: result);
              return result;
            }));
  }
}
