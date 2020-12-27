import 'package:bookshelf/common/exception/exceptions.dart';
import 'package:bookshelf/feature/book/domain/usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../mock/mock.dart';

void main() {
  group('add note use case test', () {
    test('When add note by invalid isbn Then throw error', () {
      final addNote = AddNoteUseCase(MockNoteRepository());
      expect(
        () => addNote.execute(AddNoteParam(null, 'foo')),
        throwsA(isA<InvalidParameterException>()),
      );

      expect(
        () => addNote.execute(AddNoteParam('', 'foo')),
        throwsA(isA<InvalidParameterException>()),
      );
    });

    test('When add note by invalid contents Then throw error', () {
      final addNote = AddNoteUseCase(MockNoteRepository());
      expect(
        () => addNote.execute(AddNoteParam('foo', null)),
        throwsA(isA<InvalidParameterException>()),
      );

      expect(
        () => addNote.execute(AddNoteParam('foo', '')),
        throwsA(isA<InvalidParameterException>()),
      );
    });

    test("When add note Then call create in repository by given parameters",
        () async {
      final isbn = 'isbn';
      final contents = 'contents';
      final repository = MockNoteRepository();

      when(repository.create(any, any)).thenAnswer(
        (_) => Future.value(mockNote(isbn, contents)),
      );

      final addNote = AddNoteUseCase(repository);

      final result = await addNote.execute(AddNoteParam(isbn, contents));
      verify(repository.create(isbn, contents));
      expect(result, mockNote(isbn, contents));
    });
  });
}
