import 'package:bookshelf/common/exception/exceptions.dart';
import 'package:bookshelf/feature/note/domain/usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../mock/mock.dart';

void main() {
  group('get notes use case test', () {
    test('When get notes by invalid isbn Then throw error', () {
      final getNotes = GetNotesUseCase(MockNoteRepository());
      expect(
        () => getNotes.execute(GetNotesParam(null)),
        throwsA(isA<InvalidParameterException>()),
      );

      expect(
        () => getNotes.execute(GetNotesParam('')),
        throwsA(isA<InvalidParameterException>()),
      );
    });

    test("When add note Then call getList in repository by given isbn",
        () async {
      final isbn = 'isbn';
      final repository = MockNoteRepository();

      when(repository.getList(any)).thenAnswer(
        (_) => Future.value([mockNote(isbn, 'foo')]),
      );

      final getNotes = GetNotesUseCase(repository);

      final result = await getNotes.execute(GetNotesParam(isbn));
      verify(repository.getList(isbn));
      expect(result, [mockNote(isbn, 'foo')]);
    });
  });
}
