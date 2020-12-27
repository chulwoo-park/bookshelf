mixin TypeEquatableMixin {
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  bool operator ==(Object other) => runtimeType == other.runtimeType;
}

abstract class AsyncState with TypeEquatableMixin {
  const AsyncState();
}

class Initial extends AsyncState {
  const Initial();
}

class Loading extends AsyncState {
  const Loading();
}

class Failure implements AsyncState {
  const Failure(this.error, [this.stackTrace]);

  final Object error;
  final StackTrace stackTrace;
}

class Success<T> implements AsyncState {
  const Success(this.data);

  final T data;

  @override
  int get hashCode => 31 + runtimeType.hashCode + data.hashCode;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Success<T> && data == other.data);
  }
}
