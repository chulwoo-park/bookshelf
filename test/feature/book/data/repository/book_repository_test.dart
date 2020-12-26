import 'package:bookshelf/feature/book/data/data_source.dart';
import 'package:bookshelf/feature/book/data/repository.dart';
import 'package:bookshelf/feature/book/domain/repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../mock/mock.dart';

void main() {
  group('book repository implementation test', () {
    BookRepository repository;
    LocalBookSource localSource;
    RemoteBookSource remoteSource;

    setUp(() {
      localSource = MockLocalBookSource();
      remoteSource = MockRemoteBookSource();
      repository = BookRepositoryImpl(localSource, remoteSource);
    });

    group('search test', () {
      test(
        'Given query and page When find Then cache key should be [query]_[page] format',
        () async {
          when(localSource.getList(any))
              .thenAnswer((_) => Future.value(mockPage([mockBook('a')])));
          await repository.find('query', page: 1);
          verify(localSource.getList('query_1'));
        },
      );

      test(
        'Given local data When find Then return data from local',
        () async {
          when(localSource.getList(any)).thenAnswer((_) => Future.value(
                mockPage([mockBook('a')]),
              ));

          final result = await repository.find('query');

          verify(localSource.getList(any));
          verifyNever(remoteSource.find(any));

          expect(result, [mockBook('a')]);
        },
      );

      test(
        'Given local error When find Then return data from remote',
        () async {
          when(localSource.getList(any))
              .thenAnswer((_) => Future.error(Exception()));
          when(remoteSource.find(any))
              .thenAnswer((_) => Future.value(mockPage([mockBook('a')])));

          final result = await repository.find('query');

          verifyInOrder([
            localSource.getList(any),
            remoteSource.find('query'),
          ]);

          expect(result, [mockBook('a')]);
        },
      );

      test(
        'Given local error When find Then return save remote data into local',
        () async {
          when(localSource.getList(any))
              .thenAnswer((_) => Future.error(Exception()));
          when(remoteSource.find(any))
              .thenAnswer((_) => Future.value(mockPage([mockBook('a')])));

          await repository.find('query');

          verifyInOrder([
            localSource.getList(any),
            remoteSource.find(any),
            localSource.saveList(any, mockPage([mockBook('a')])),
          ]);
        },
      );
    });
  });
}
