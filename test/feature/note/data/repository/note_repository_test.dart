import 'package:bookshelf/feature/book/data/data_source.dart';
import 'package:bookshelf/feature/book/data/repository.dart';
import 'package:bookshelf/feature/book/domain/model.dart';
import 'package:bookshelf/feature/book/domain/repository.dart';
import 'package:bookshelf/feature/note/data/data_source.dart';
import 'package:bookshelf/feature/note/data/repository.dart';
import 'package:bookshelf/feature/note/domain/repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../mock/mock.dart';

void main() {
  group('note repository implementation test', () {
    NoteRepository repository;
    LocalNoteSource localSource;

    setUp(() {
      localSource = MockLocalNoteSource();
      repository = NoteRepositoryImpl(localSource);
    });

    group('create test', () {
      test(
        'When create Then returns created data',
        () async {
          final note = mockNote('isbn', 'contents');
          when(localSource.add(note)).thenAnswer((_) => Future.value());
          final result = await repository.create('isbn', 'contents');
          verify(localSource.add(any));
          expect(result, mockNote('isbn', 'contents'));
        },
      );

      test(
        'Given local error When create Then throws error',
        () async {
          when(localSource.add(any))
              .thenAnswer((_) => Future.error(Exception()));
          expectLater(
              repository.create('foo', 'bar'), throwsA(isA<Exception>()));
        },
      );
    });

    group('getList test', () {
      test(
        'Given local data When getList Then return data from local',
        () async {
          when(localSource.getList('isbn')).thenAnswer(
            (_) => Future.value(
              [
                mockNote('isbn', 'a'),
                mockNote('isbn', 'b'),
              ],
            ),
          );

          final result = await repository.getList('isbn');
          verify(localSource.getList('isbn'));
          expect(result, [
            mockNote('isbn', 'a'),
            mockNote('isbn', 'b'),
          ]);
        },
      );

      test(
        'Given local error When getList Then throws error',
        () async {
          when(localSource.getList(any))
              .thenAnswer((_) => Future.error(Exception()));

          expectLater(repository.getList('isbn'), throwsA(isA<Exception>()));
        },
      );
    });
  });
}
