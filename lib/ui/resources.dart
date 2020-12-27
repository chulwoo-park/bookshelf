class R {
  static const _Colors _colors = _Colors();
  static _Colors get colors => _colors;

  static const _Strings _strings = _Strings();
  static _Strings get strings => _strings;
}

class _Colors {
  const _Colors();
}

class _Strings {
  const _Strings();

  final searchTitle = 'Search';
  final searchHint = 'Titles, Authors, ISBN and More';
  final searchEmptyMessage = 'No results found.';
  final searchErrorMessage = 'Search failed.\nPlease try again.';

  final detailErrorMessage = 'Load failed.\nPlease try again.';

  final retry = 'retry';

  final free = 'free';
}
