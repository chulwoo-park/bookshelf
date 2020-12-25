import 'package:bookshelf/feature/book/data/repository/repository.dart';
import 'package:bookshelf/feature/book/data/source/data_source.dart';
import 'package:bookshelf/feature/book/domain/model/book.dart';
import 'package:bookshelf/feature/book/domain/repository/repository.dart';
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
        'Given local data When find Then return data from local',
        () async {
          final query = 'query';

          when(localSource.find(query))
              .thenAnswer((_) => Future.value([Book('a')]));

          final result = await repository.find(query);

          verify(localSource.find(query));
          verifyNever(remoteSource.find(query));

          expect(result, [Book('a')]);
        },
      );

      test(
        'Given local error When find Then return data from remote',
        () async {
          final query = 'query';

          when(localSource.find(query))
              .thenAnswer((_) => Future.error(Exception()));
          when(remoteSource.find(query))
              .thenAnswer((_) => Future.value([Book('a')]));

          final result = await repository.find(query);

          verifyInOrder([
            localSource.find(query),
            remoteSource.find(query),
          ]);

          expect(result, [Book('a')]);
        },
      );

      test(
        'Given local error When find Then return save remote data into local',
        () async {
          final query = 'query';

          when(localSource.find(query))
              .thenAnswer((_) => Future.error(Exception()));
          when(remoteSource.find(query))
              .thenAnswer((_) => Future.value([Book('a')]));

          await repository.find(query);

          verifyInOrder([
            localSource.find(query),
            remoteSource.find(query),
            localSource.save(query: query, page: 1, data: [Book('a')]),
          ]);
        },
      );
    });
  });
}
