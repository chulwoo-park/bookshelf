import 'package:bookshelf/common/model/state.dart';
import 'package:bookshelf/feature/note/domain/model.dart';
import 'package:flutter/foundation.dart';

abstract class NoteListState with TypeEquatableMixin {
  const NoteListState();
}

class Initial extends NoteListState {}

class Loading extends NoteListState {}

class Success extends NoteListState {
  const Success(this.data);

  final List<Note> data;

  @override
  int get hashCode => super.hashCode + data.hashCode;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Success && listEquals(other.data, data));
  }
}

class Failure extends NoteListState {
  const Failure(this.data, this.error, [this.stackTrace]);

  final List<Note> data;
  final Object error;
  final StackTrace stackTrace;

  @override
  int get hashCode => super.hashCode + data.hashCode;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Success && listEquals(other.data, data));
  }
}
