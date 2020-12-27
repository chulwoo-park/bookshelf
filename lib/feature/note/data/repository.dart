import 'package:bookshelf/feature/note/domain/model.dart';
import 'package:bookshelf/feature/note/domain/repository.dart';

import 'data_source.dart';

class NoteRepositoryImpl implements NoteRepository {
  const NoteRepositoryImpl(this._localSource);

  final LocalNoteSource _localSource;

  @override
  Future<Note> create(String isbn13, String contents) {
    final note = Note(isbn13, contents);
    return _localSource.add(note).then((_) => note);
  }

  @override
  Future<List<Note>> getList(String isbn13) {
    return _localSource.getList(isbn13);
  }
}
