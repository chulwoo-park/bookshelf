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
  Stream<NoteListState> mapEventToState(NoteEvent event) async* {}
}
