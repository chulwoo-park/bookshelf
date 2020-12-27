import 'package:bookshelf/common/exception/exceptions.dart';
import 'package:bookshelf/feature/book/domain/usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../mock/mock.dart';

void main() {
  group('Search use case test', () {
    test('When search by empty query Then throw error', () async {
      final searchBook = SearchBookUseCase(MockBookRepository());
      expect(
        () => searchBook.execute(SearchBookParam(null)),
        throwsA(isA<InvalidParameterException>()),
      );

      expect(
        () => searchBook.execute(SearchBookParam('')),
        throwsA(isA<InvalidParameterException>()),
      );
    });

    test("When search without specific page Then call search with page 1", () {
      final param = SearchBookParam('foo');

      expect(param.page, 1);
    });

    test(
        "When search by some query Then call find in repository by given query",
        () async {
      final query = 'mongodb';
      final repository = MockBookRepository();

      when(repository.find(query)).thenAnswer(
        (_) => Future.value(
          mockPage([
            mockBook('a'),
            mockBook('b'),
          ]),
        ),
      );

      final searchBook = SearchBookUseCase(repository);

      final result = await searchBook.execute(SearchBookParam(query));
      verify(repository.find(query));
      expect(result, [mockBook('a'), mockBook('b')]);
    });
  });
}
