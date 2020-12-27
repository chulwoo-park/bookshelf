class Note {
  const Note(
    this.isbn13,
    this.contents,
  );

  final String isbn13;
  final String contents;

  @override
  int get hashCode => 31 + isbn13.hashCode + contents.hashCode;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Note && isbn13 == other.isbn13 && contents == other.contents);
  }
}
