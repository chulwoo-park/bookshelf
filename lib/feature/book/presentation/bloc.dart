import 'package:bookshelf/feature/book/domain/usecase.dart';
import 'package:bookshelf/feature/book/presentation/event.dart';
import 'package:bookshelf/feature/book/presentation/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookListBloc extends Bloc<BookListEvent, BookListState> {
  BookListBloc(this._search) : super(Initial());

  final SearchUseCase _search;

  @override
  Stream<BookListState> mapEventToState(BookListEvent event) {
    // TODO: implement mapEventToState
    throw UnimplementedError();
  }
}
