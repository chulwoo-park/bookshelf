import 'package:bookshelf/common/model/page.dart';
import 'package:bookshelf/feature/book/data/data_source.dart';
import 'package:bookshelf/feature/book/domain/model.dart';
import 'package:bookshelf/feature/book/domain/repository.dart';

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

class NoteRepositoryImpl implements NoteRepository {
  const NoteRepositoryImpl(this._localSource);

  final LocalNoteSource _localSource;

  @override
  Future<Note> create(String isbn, String contents) {
    final note = Note(isbn, contents);
    return _localSource.add(note).then((_) => note);
  }

  @override
  Future<List<Note>> getList(String isbn) {
    return _localSource.getList(isbn);
  }
}
