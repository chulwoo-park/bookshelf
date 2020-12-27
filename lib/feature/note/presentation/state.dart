import 'package:bookshelf/common/model/state.dart';
import 'package:bookshelf/feature/note/domain/model.dart';
import 'package:flutter/foundation.dart';

abstract class NoteListState with TypeEquatableMixin {
  const NoteListState();
}

class Initial extends NoteListState {}

class Loading extends NoteListState {}

mixin HasDataState on NoteListState {
  List<Note> get data;

  @override
  int get hashCode => super.hashCode + data.hashCode;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is HasDataState && listEquals(other.data, data));
  }
}

class Success extends NoteListState with HasDataState {
  const Success(this.data);

  @override
  final List<Note> data;
}

class Failure extends NoteListState {
  const Failure(this.error, [this.stackTrace]);

  final Object error;
  final StackTrace stackTrace;
}

class FailureAdd extends Failure with HasDataState {
  const FailureAdd(this.data, Object error, [StackTrace stackTrace])
      : super(error, stackTrace);

  @override
  final List<Note> data;

  @override
  int get hashCode => super.hashCode;

  @override
  bool operator ==(Object other) {
    return identical(other, this);
  }
}
