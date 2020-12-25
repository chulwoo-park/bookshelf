import 'package:bookshelf/common/exception/exceptions.dart';
import 'package:bookshelf/feature/book/domain/model/book.dart';
import 'package:bookshelf/feature/book/domain/repository/repository.dart';

class SearchParam {
  const SearchParam(this.query, {this.page = 1});

  final String query;
  final int page;
}

class SearchUseCase {
  const SearchUseCase(this._repository);

  final BookRepository _repository;

  Future<List<Book>> execute(SearchParam param) {
    if (param.query == null || param.query.isEmpty) {
      throw InvalidQueryException();
    }
    return _repository.find(param.query, page: param.page);
  }
}
