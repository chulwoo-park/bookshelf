class SearchResponseVo {
  const SearchResponseVo(
    this.error,
    this.total,
    this.page,
    this.books,
  );

  final String error;
  final int total;
  final int page;
  final List<BookVo> books;

  bool get isSuccess => error == '0';
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
