import 'package:bookshelf/common/model/page.dart';
import 'package:bookshelf/feature/book/data/data_source.dart';
import 'package:bookshelf/feature/book/domain/model.dart';
import 'package:bookshelf/feature/book/domain/repository.dart';
import 'package:bookshelf/feature/book/domain/usecase.dart';
import 'package:mockito/mockito.dart';

Page<Book> mockPage(List<Book> books, {int totalCount}) {
  return Page(page: 1, totalCount: totalCount ?? books.length, items: books);
}

Book mockBook(String title) {
  return Book(title, title, title, 0.0, '', '');
}

BookDetail mockBookDetail(String isbn13) {
  return BookDetail(
    isbn13,
    isbn13,
    isbn13,
    isbn13,
    isbn13,
    isbn13,
    1,
    2020,
    5.0,
    isbn13,
    0.0,
    '',
    '',
    [],
  );
}

Note mockNote(
  String isbn, [
  String contents,
]) {
  return Note(isbn, contents ?? isbn);
}

class MockSearchUseCase extends Mock implements SearchUseCase {}

class MockGetDetailUseCase extends Mock implements GetDetailUseCase {}

class MockBookRepository extends Mock implements BookRepository {}

class MockNoteRepository extends Mock implements NoteRepository {}

class MockLocalBookSource extends Mock implements LocalBookSource {}

class MockRemoteBookSource extends Mock implements RemoteBookSource {}

class MockLocalNoteSource extends Mock implements LocalNoteSource {}
