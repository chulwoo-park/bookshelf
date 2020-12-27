abstract class ResponseVo {
  const ResponseVo(this.error);

  final String error;

  bool get isSuccess => error == '0';
}

class SearchResponseVo extends ResponseVo {
  const SearchResponseVo(
    String error,
    this.total,
    this.page,
    this.books,
  ) : super(error);

  final int total;
  final int page;
  final List<BookVo> books;
}

class BookVo {
  const BookVo({
    this.title,
    this.subtitle,
    this.isbn13,
    this.price,
    this.image,
    this.url,
  });

  final String title;
  final String subtitle;
  final String isbn13;
  final String price;
  final String image;
  final String url;
}

class BookDetailResponseVo extends ResponseVo {
  const BookDetailResponseVo({
    String error,
    this.title,
    this.subtitle,
    this.authors,
    this.publisher,
    this.isbn10,
    this.isbn13,
    this.pages,
    this.year,
    this.rating,
    this.desc,
    this.price,
    this.image,
    this.url,
    this.pdf,
  }) : super(error);

  final String title;
  final String subtitle;
  final String authors;
  final String publisher;
  final String isbn10;
  final String isbn13;
  final String pages;
  final String year;
  final String rating;
  final String desc;
  final String price;
  final String image;
  final String url;
  final Map<String, dynamic> pdf;
}
