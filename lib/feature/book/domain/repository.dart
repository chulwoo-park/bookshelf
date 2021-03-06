import 'package:bookshelf/common/model/page.dart';

import 'model.dart';

abstract class BookRepository {
  /// {@template find_book}
  /// Find books by [query]. [query] can be title, author, ISBN or keywords.
  ///
  /// Results are paginated, and each page can be accessed by [page].
  /// {@endtemplate}
  Future<Page<Book>> find(String query, {int page = 1});

  /// {@template book_detail}
  /// Returns detail information of book by [isbn13].
  /// {@endtemplate}
  Future<BookDetail> getDetail(String isbn13);
}
