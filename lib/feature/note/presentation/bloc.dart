import 'package:bookshelf/common/model/state.dart';
import 'package:bookshelf/feature/note/domain/usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'event.dart';

class NoteListBloc extends Bloc<NoteEvent, AsyncState> {
  NoteListBloc(this._addNote, this._getNotes) : super(Initial());

  final AddNoteUseCase _addNote;
  final GetNotesUseCase _getNotes;

  @override
  Stream<AsyncState> mapEventToState(NoteEvent event) async* {}
}
