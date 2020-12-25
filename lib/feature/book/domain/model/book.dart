class Book {
  const Book(this.title);

  final String title;

  @override
  int get hashCode => title.hashCode;

  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other is Book && other.title == title);
  }
}
