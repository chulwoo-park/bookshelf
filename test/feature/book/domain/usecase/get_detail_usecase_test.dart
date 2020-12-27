import 'package:bookshelf/common/exception/exceptions.dart';
import 'package:bookshelf/feature/book/domain/repository.dart';
import 'package:bookshelf/feature/book/domain/usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../mock/mock.dart';

void main() {
  group('get detail use case test', () {
    test('When get detail without isbn13 Then throw error', () {
      final searchBook = GetBookDetailUseCase(MockBookRepository());
      expect(
        () => searchBook.execute(GetBookDetailParam(null)),
        throwsA(isA<InvalidParameterException>()),
      );

      expect(
        () => searchBook.execute(GetBookDetailParam('')),
        throwsA(isA<InvalidParameterException>()),
      );
    });

    test(
        "When get detail by some isbn13 Then call getDetail in repository by given isbn13",
        () async {
      final isbn13 = 'foo';
      final BookRepository repository = MockBookRepository();

      when(repository.getDetail(any)).thenAnswer(
        (_) => Future.value(mockBookDetail('a')),
      );

      final getDetail = GetBookDetailUseCase(repository);

      final result = await getDetail.execute(GetBookDetailParam(isbn13));
      verify(repository.getDetail(isbn13));
      expect(result, mockBookDetail('a'));
    });
  });
}
