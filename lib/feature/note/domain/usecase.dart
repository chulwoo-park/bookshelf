import 'package:bookshelf/common/exception/exceptions.dart';

import 'model.dart';
import 'repository.dart';

class AddNoteParam {
  const AddNoteParam(this.isbn13, this.contents);

  final String isbn13;
  final String contents;
}

/// Allows the user to take a note.
class AddNoteUseCase {
  const AddNoteUseCase(this._repository);

  final NoteRepository _repository;

  Future<Note> execute(AddNoteParam param) {
    if (param.isbn13 == null ||
        param.isbn13.isEmpty ||
        param.contents == null ||
        param.contents.isEmpty) {
      throw InvalidParameterException();
    }

    return _repository.create(param.isbn13, param.contents);
  }
}

class GetNotesParam {
  const GetNotesParam(this.isbn13);

  final String isbn13;
}

/// Allows the user to take a note.
class GetNotesUseCase {
  const GetNotesUseCase(this._repository);

  final NoteRepository _repository;

  Future<List<Note>> execute(GetNotesParam param) {
    if (param.isbn13 == null || param.isbn13.isEmpty) {
      throw InvalidParameterException();
    }

    return _repository.getList(param.isbn13);
  }
}
