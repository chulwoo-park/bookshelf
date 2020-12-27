abstract class NoteEvent {}

class NoteListRequested implements NoteEvent {
  const NoteListRequested();
}

class NoteAdded implements NoteEvent {
  const NoteAdded(this.contents);

  final String contents;
}
