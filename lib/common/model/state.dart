abstract class AsyncState {
  const AsyncState();

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  bool operator ==(Object other) => runtimeType == other.runtimeType;
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
}