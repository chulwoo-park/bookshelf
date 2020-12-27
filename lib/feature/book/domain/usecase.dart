import 'package:bookshelf/common/exception/exceptions.dart';
import 'package:bookshelf/common/model/page.dart';
import 'package:bookshelf/feature/book/domain/model.dart';
import 'package:bookshelf/feature/book/domain/repository.dart';

class SearchParam {
  const SearchParam(this.query, {this.page = 1});

  final String query;
  final int page;

  @override
  int get hashCode => 31 + query.hashCode + page.hashCode;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is SearchParam && query == other.query && page == other.page);
  }
}

/// Shows book search information for specific keywords.
/// The searched data is cached.
class SearchUseCase {
  const SearchUseCase(this._repository);

  final BookRepository _repository;

  Future<Page<Book>> execute(SearchParam param) {
    if (param.query == null || param.query.isEmpty) {
      throw InvalidParameterException();
    }
    return _repository.find(param.query, page: param.page);
  }
}

class GetDetailParam {
  const GetDetailParam(this.isbn13);

  final String isbn13;
}

/// Shows detailed information of the selected book among the book list.
class GetDetailUseCase {
  const GetDetailUseCase(this._repository);

  final BookRepository _repository;

  Future<BookDetail> execute(GetDetailParam param) {
    if (param.isbn13 == null || param.isbn13.isEmpty) {
      throw InvalidParameterException();
    }
    return _repository.getDetail(param.isbn13);
  }
}

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
