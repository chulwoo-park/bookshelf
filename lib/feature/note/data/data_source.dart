import 'package:bookshelf/feature/note/domain/model.dart';

abstract class LocalNoteSource {
  /// Returns the data for the given [key] or returns empty list if [key] is
  /// not in the local source.
  Future<List<Note>> getList(String isbn13);

  /// Save [data].
  Future<void> add(Note data);
}
