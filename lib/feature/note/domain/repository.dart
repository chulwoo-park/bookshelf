import 'model.dart';

abstract class NoteRepository {
  /// {@template create_note}
  /// Create note with [contents] and returns created data.
  /// {@endtemplate}
  Future<Note> create(String isbn, String contents);

  /// {@template get_note_list}
  /// Returns a list of notes that related to book using [isbn] of that book.
  /// {@endtemplate}
  Future<List<Note>> getList(String isbn);
}
