import 'package:bookshelf/feature/book/domain/model/book.dart';

abstract class BookRepository {
  Future<List<Book>> find(String query, {int page = 1});
}
