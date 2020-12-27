class Note {
  const Note(
    this.isbn,
    this.contents,
  );

  final String isbn;
  final String contents;

  @override
  int get hashCode => 31 + isbn.hashCode + contents.hashCode;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Note && isbn == other.isbn && contents == other.contents);
  }
}
