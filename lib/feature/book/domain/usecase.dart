import 'package:bookshelf/common/exception/exceptions.dart';
import 'package:bookshelf/common/model/page.dart';

import 'model.dart';
import 'repository.dart';

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
