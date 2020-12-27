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

class BookDetail {
  const BookDetail(
    this.title,
    this.subtitle,
    this.authors,
    this.publisher,
    this.isbn10,
    this.isbn13,
    this.pages,
    this.year,
    this.rating,
    this.description,
    this.price,
    this.image,
    this.url,
    this.pdfs,
  )   : assert(isbn13 != null),
        assert(title != null);

  final String title;
  final String subtitle;
  final String authors;
  final String publisher;
  final String isbn10;
  final String isbn13;
  final int pages;
  final int year;
  final double rating;
  final String description;
  final double price;
  final String image;
  final String url;
  final List<Pdf> pdfs;

  bool get isFree => price == null || price == 0.0;

  @override
  int get hashCode => isbn13.hashCode;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is BookDetail && other.isbn13 == isbn13);
  }
}

class Pdf {
  const Pdf(this.title, this.url);

  final String title;
  final String url;

  @override
  int get hashCode => 31 + title.hashCode + url.hashCode;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Pdf && title == other.title && url == other.url);
  }
}

class Note {
  const Note();
}
