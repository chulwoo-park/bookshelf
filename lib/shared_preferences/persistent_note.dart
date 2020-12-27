import 'package:bookshelf/feature/note/data/data_source.dart';
import 'package:bookshelf/feature/note/domain/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersistentNote extends LocalNoteSource {
  List<Note> _getList(SharedPreferences prefs, String isbn) {
    if (prefs.containsKey(isbn)) {
      return prefs
          .getStringList(isbn)
          .map((contents) => Note(isbn, contents))
          .toList();
    } else {
      return [];
    }
  }

  Future<void> _saveList(
      SharedPreferences prefs, String isbn, List<Note> notes) {
    if (notes.isEmpty) {
      return prefs.remove(isbn);
    } else {
      return prefs.setStringList(
          isbn, notes.map((note) => note.contents).toList());
    }
  }

  @override
  Future<List<Note>> getList(String key) {
    return SharedPreferences.getInstance().then((pref) => _getList(pref, key));
  }

  @override
  Future<void> add(Note data) {
    return SharedPreferences.getInstance().then(
      (pref) async {
        List<Note> notes = _getList(pref, data.isbn);
        notes.add(data);

        return _saveList(pref, data.isbn, notes);
      },
    );
  }
}
