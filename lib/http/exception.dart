class ClientError implements Exception {
  const ClientError(this.code, this.body);

  final int code;
  final String body;
}

class ServerError implements Exception {
  const ServerError(this.code, this.body);

  final int code;
  final String body;
}

class RequestFailure implements Exception {
  const RequestFailure(this.message);

  final String message;
}

class ParsingException implements Exception {
  const ParsingException(this.error);

  final Object error;
}
