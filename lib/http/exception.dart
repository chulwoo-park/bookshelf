class RequestFailure implements Exception {
  const RequestFailure(this.message);

  final String message;
}

class ParsingException implements Exception {
  const ParsingException(this.error);

  final Object error;
}
