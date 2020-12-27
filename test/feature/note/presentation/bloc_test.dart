import 'package:bookshelf/feature/note/domain/model.dart';
import 'package:bookshelf/feature/note/domain/usecase.dart';
import 'package:bookshelf/feature/note/presentation/bloc.dart';
import 'package:bookshelf/feature/note/presentation/event.dart';
import 'package:bookshelf/feature/note/presentation/state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mock/mock.dart';

void main() {
  group('note bloc test', () {
    group('note added event test', () {
      AddNoteUseCase addNote;
      GetNotesUseCase getNotes;
      NoteListBloc bloc;

      final isbn = 'isbn';

      setUp(() {
        getNotes = MockGetNotesUseCase();
        addNote = MockAddNoteUseCase();
        bloc = NoteListBloc(isbn, addNote, getNotes);
      });

      test(
        'When note added Then state changed to success and note list updated',
        () {
          when(getNotes.execute(any)).thenAnswer((_) {
            return Future.value([
              mockNote(isbn, 'a'),
              mockNote(isbn, 'b'),
            ]);
          });

          when(addNote.execute(any)).thenAnswer((invocation) {
            final AddNoteParam param = invocation.positionalArguments[0];
            return Future.value(Note(
              isbn,
              param.contents,
            ));
          });

          expect(bloc.state, isA<Initial>());
          bloc.add(NoteListRequested());
          bloc.add(NoteAdded('contents'));
          expectLater(
            bloc,
            emitsInOrder(
              [
                isA<Loading>(),
                Success([
                  mockNote(isbn, 'a'),
                  mockNote(isbn, 'b'),
                ]),
                Success([
                  mockNote(isbn, 'a'),
                  mockNote(isbn, 'b'),
                  mockNote(isbn, 'contents'),
                ]),
              ],
            ),
          );
        },
      );

      test(
        'Given error When note added Then state changed to failure with previous data',
        () {
          when(getNotes.execute(any)).thenAnswer(
            (_) => Future.value([
              mockNote(isbn, 'a'),
              mockNote(isbn, 'b'),
            ]),
          );
          when(addNote.execute(any))
              .thenAnswer((_) => Future.error(Exception()));

          expect(bloc.state, isA<Initial>());

          bloc.add(NoteListRequested());
          bloc.add(NoteAdded('contents'));

          expectLater(
            bloc,
            emitsInOrder(
              [
                isA<Loading>(),
                Success(
                  [
                    mockNote(isbn, 'a'),
                    mockNote(isbn, 'b'),
                  ],
                ),
                FailureAdd(
                  [
                    mockNote(isbn, 'a'),
                    mockNote(isbn, 'b'),
                  ],
                  Exception(),
                ),
              ],
            ),
          );
        },
      );
    });
  });
}
