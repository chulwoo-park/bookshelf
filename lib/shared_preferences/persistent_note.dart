import 'package:bookshelf/feature/note/data/data_source.dart';
import 'package:bookshelf/feature/note/domain/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersistentNote extends LocalNoteSource {
  String _keyOf(String isbn) {
    return 'note_$isbn';
  }

  List<Note> _getList(SharedPreferences prefs, String key) {
    if (prefs.containsKey(key)) {
      return prefs
          .getStringList(key)
          .map((contents) => Note(key, contents))
          .toList();
    } else {
      return [];
    }
  }

  Future<void> _saveList(
      SharedPreferences prefs, String key, List<Note> notes) {
    if (notes.isEmpty) {
      return prefs.remove(key);
    } else {
      return prefs.setStringList(
        key,
        notes.map((note) => note.contents).toList(),
      );
    }
  }

  @override
  Future<List<Note>> getList(String isbn13) {
    return SharedPreferences.getInstance()
        .then((pref) => _getList(pref, _keyOf(isbn13)));
  }

  @override
  Future<void> add(Note data) {
    return SharedPreferences.getInstance().then(
      (pref) async {
        List<Note> notes = _getList(pref, _keyOf(data.isbn13));
        notes.add(data);

        return _saveList(pref, _keyOf(data.isbn13), notes);
      },
    );
  }
}
