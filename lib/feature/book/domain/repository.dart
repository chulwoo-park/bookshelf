import 'package:bookshelf/common/model/page.dart';
import 'package:bookshelf/feature/book/domain/model.dart';

abstract class BookRepository {
  /// {@template find_book}
  /// Find books by [query]. [query] can be title, author, ISBN or keywords.
  ///
  /// Results are paginated, and each page can be accessed by [page].
  /// {@endtemplate}
  Future<Page<Book>> find(String query, {int page = 1});

  Future<BookDetail> getDetail(any);
}
