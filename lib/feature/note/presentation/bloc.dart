import 'package:bookshelf/feature/note/domain/model.dart';
import 'package:bookshelf/feature/note/domain/usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'event.dart';
import 'state.dart';

class NoteListBloc extends Bloc<NoteEvent, NoteListState> {
  NoteListBloc(this.isbn, this._addNote, this._getNotes) : super(Initial());

  final String isbn;
  final AddNoteUseCase _addNote;
  final GetNotesUseCase _getNotes;

  @override
  Stream<NoteListState> mapEventToState(NoteEvent event) async* {
    if (event is NoteListRequested) {
      yield* _mapNoteListRequestedEvent(event);
    } else if (event is NoteAdded) {
      yield* _mapNoteAddedEvent(event);
    }
  }

  Stream<NoteListState> _mapNoteListRequestedEvent(
    NoteListRequested event,
  ) async* {
    if (state is Loading) {
      return;
    }

    yield Loading();

    try {
      final result = await _getNotes.execute(GetNotesParam(isbn));
      yield Success(result);
    } catch (e, s) {
      yield Failure(e, s);
    }
  }

  Stream<NoteListState> _mapNoteAddedEvent(NoteAdded event) async* {
    if (state is Loading) {
      return;
    }

    final prevState = state;
    List<Note> prevData;
    if (prevState is Success) {
      prevData = prevState.data;
    } else if (prevState is FailureAdd) {
      prevData = prevState.data;
    } else {
      prevData = [];
    }

    try {
      final result = await _addNote.execute(AddNoteParam(isbn, event.contents));
      yield Success(List.unmodifiable(prevData + [result]));
    } catch (e, s) {
      yield FailureAdd(prevData, e, s);
    }
  }
}
