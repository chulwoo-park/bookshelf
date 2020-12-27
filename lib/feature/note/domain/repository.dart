import 'model.dart';

abstract class NoteRepository {
  Future<Note> create(String isbn, String contents);

  Future<List<Note>> getList(String isbn);
}
