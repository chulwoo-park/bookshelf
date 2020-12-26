import 'package:bookshelf/feature/book/domain/model.dart';
import 'package:bookshelf/feature/book/domain/usecase.dart';
import 'package:bookshelf/feature/book/presentation/bloc.dart';
import 'package:bookshelf/feature/book/presentation/event.dart';
import 'package:bookshelf/feature/book/presentation/state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mock/mock.dart';
import '../../../util/util.dart';

void main() {
  group('book list block test', () {
    group('book searched event test', () {
      SearchUseCase search;
      BookListBloc bloc;

      setUp(() {
        search = MockSearchUseCase();
        bloc = BookListBloc(search);
      });

      test(
        'Given error When book searched Then state change to failure',
        () {
          when(search.execute(any))
              .thenAnswer((_) => Future.error(Exception()));
          expect(bloc.state, isA<Initial>());
          bloc.add(BookSearched('query'));
          expectLater(
            bloc,
            emitsInOrder(
              [
                isA<Loading>(),
                isA<Failure>(),
              ],
            ),
          );
        },
      );

      test(
        'Given some data When book searched by query Then state change to success with idle load more state',
        () {
          when(search.execute(any)).thenAnswer((_) => Future.value([]));

          expect(bloc.state, isA<Initial>());
          bloc.add(BookSearched('query'));
          expectLater(
            bloc,
            emitsInOrder(
              [
                isA<Loading>(),
                Success(
                  [],
                  query: 'query',
                  loadMoreState: BookListLoadMoreState.idle,
                ),
              ],
            ),
          );
        },
      );

      test('Given failure state When load more Then next page never loaded',
          () async {
        when(search.execute(any))
            .thenAnswer((realInvocation) => Future.error(Exception()));
        bloc.add(BookSearched('foo'));
        expect(await bloc.take(2).last, isA<Failure>());

        await bloc.addAndSettle(NextPageRequested());
        await bloc.close();
        expect(await bloc.length, 0);
      });

      test(
          'Given error When load more Then state change to success with failure load more state',
          () async {
        when(search.execute(SearchParam('query', page: 1)))
            .thenAnswer((_) => Future.value([]));
        when(search.execute(SearchParam('query', page: 2)))
            .thenAnswer((_) => Future.error(Exception()));

        expect(bloc.state, isA<Initial>());
        bloc.addAndSettle(BookSearched('query'));
        bloc.addAndSettle(NextPageRequested());
        expectLater(
          bloc,
          emitsInOrder(
            [
              isA<Loading>(),
              isA<Success>(),
              Success(
                [],
                query: 'query',
                loadMoreState: BookListLoadMoreState.loading,
              ),
              Success(
                [],
                query: 'query',
                loadMoreState: BookListLoadMoreState.failure,
              ),
            ],
          ),
        );
      });
      test(
        'Given success state When load more Then the loaded data is added to end of previous data',
        () {
          when(search.execute(SearchParam('query', page: 1)))
              .thenAnswer((_) => Future.value([Book('a')]));
          when(search.execute(SearchParam('query', page: 2)))
              .thenAnswer((_) => Future.value([Book('b')]));

          expect(bloc.state, isA<Initial>());
          bloc.add(BookSearched('query'));
          bloc.add(NextPageRequested());
          expectLater(
            bloc,
            emitsInOrder(
              [
                isA<Loading>(),
                Success(
                  [Book('a')],
                  query: 'query',
                  page: 1,
                  loadMoreState: BookListLoadMoreState.idle,
                ),
                Success(
                  [Book('a')],
                  query: 'query',
                  page: 1,
                  loadMoreState: BookListLoadMoreState.loading,
                ),
                Success(
                  [Book('a'), Book('b')],
                  query: 'query',
                  page: 2,
                  loadMoreState: BookListLoadMoreState.idle,
                ),
              ],
            ),
          );
        },
      );
    });
  });
}
