import 'package:bookshelf/feature/book/domain/usecase.dart';
import 'package:bookshelf/feature/book/presentation/event.dart';
import 'package:bookshelf/feature/book/presentation/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookListBloc extends Bloc<BookListEvent, BookListState> {
  BookListBloc(this._search) : super(Initial());

  final SearchUseCase _search;

  @override
  Stream<BookListState> mapEventToState(BookListEvent event) async* {
    if (event is BookSearched) {
      yield* _mapSearchEvent(event);
    } else if (event is NextPageRequested) {
      yield* _mapNextPageRequestedEvent(event);
    }
  }

  Stream<BookListState> _mapSearchEvent(BookSearched event) async* {
    if (state is Loading) {
      return;
    }

    yield Loading();
    try {
      final result = await _search.execute(
        SearchParam(
          event.query,
          page: 1,
        ),
      );
      yield Success(
        List.unmodifiable(result),
        query: event.query,
        page: 1,
      );
    } catch (e, s) {
      yield Failure(e, s);
    }
  }

  Stream<BookListState> _mapNextPageRequestedEvent(
    NextPageRequested event,
  ) async* {
    if (this.state is! Success) {
      return;
    }

    final Success state = this.state;
    if (state.loadMoreState == BookListLoadMoreState.loading) {
      return;
    }

    yield state.copyWith(loadMoreState: BookListLoadMoreState.loading);

    try {
      final result = await _search.execute(
        SearchParam(
          state.query,
          page: state.page + 1,
        ),
      );

      var loadMoreState;
      if (result.isEmpty) {
        loadMoreState = BookListLoadMoreState.reachedEnd;
      } else {
        loadMoreState = BookListLoadMoreState.idle;
      }
      yield state.copyWith(
        data: List.unmodifiable(
          state.data + result,
        ),
        page: state.page + 1,
        loadMoreState: loadMoreState,
      );
    } catch (e) {
      yield state.copyWith(
        loadMoreState: BookListLoadMoreState.failure,
      );
    }
  }
}
