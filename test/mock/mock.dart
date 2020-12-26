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

class MockSearchUseCase extends Mock implements SearchUseCase {}

class MockBookRepository extends Mock implements BookRepository {}

class MockLocalBookSource extends Mock implements LocalBookSource {}

class MockRemoteBookSource extends Mock implements RemoteBookSource {}
