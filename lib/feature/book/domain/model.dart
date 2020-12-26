class Book {
  const Book(
    this.title,
    this.subtitle,
    this.isbn13,
    this.price,
    this.image,
    this.url,
  )   : assert(isbn13 != null),
        assert(title != null),
        assert(price != null);

  final String title;
  final String subtitle;
  final String isbn13;
  final double price;
  final String image;
  final String url;

  @override
  int get hashCode {
    return isbn13.hashCode;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other is Book && other.isbn13 == isbn13);
  }
}
