import 'package:bookshelf/common/model/state.dart';
import 'package:bookshelf/feature/book/domain/usecase.dart';
import 'package:bookshelf/feature/book/presentation/event.dart';
import 'package:bookshelf/feature/book/presentation/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookListBloc extends Bloc<BookListEvent, AsyncState> {
  BookListBloc(this._search) : super(Initial());

  final SearchUseCase _search;

  @override
  Stream<AsyncState> mapEventToState(BookListEvent event) async* {
    if (event is BookSearched) {
      yield* _mapSearchEvent(event);
    } else if (event is NextPageRequested) {
      yield* _mapNextPageRequestedEvent(event);
    }
  }

  Stream<AsyncState> _mapSearchEvent(BookSearched event) async* {
    if (state is Loading || event.query == null || event.query.isEmpty) {
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
      yield BookListLoaded(
        List.unmodifiable(result),
        totalCount: result.totalCount,
        query: event.query,
        page: 1,
      );
    } catch (e, s) {
      yield Failure(e, s);
    }
  }

  Stream<AsyncState> _mapNextPageRequestedEvent(
    NextPageRequested event,
  ) async* {
    if (this.state is! BookListLoaded) {
      return;
    }

    final BookListLoaded state = this.state;
    if (state.loadMoreState == BookListLoadMoreState.loading ||
        state.totalCount == state.items.length) {
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
          state.items + result,
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

class BookDetailBloc extends Bloc<BookDetailEvent, AsyncState> {
  BookDetailBloc(this._getDetail) : super(Initial());

  final GetDetailUseCase _getDetail;

  @override
  Stream<AsyncState> mapEventToState(BookDetailEvent event) async* {
    if (event is BookDetailRequested) {
      yield* _mapDetailRequestedEvent(event);
    }
  }

  Stream<AsyncState> _mapDetailRequestedEvent(
    BookDetailRequested event,
  ) async* {
    if (state is Loading || event.isbn13 == null || event.isbn13.isEmpty) {
      return;
    }

    yield Loading();
    try {
      final result = await _getDetail.execute(GetDetailParam(event.isbn13));
      yield Success(result);
    } catch (e, s) {
      yield Failure(e, s);
    }
  }
}
