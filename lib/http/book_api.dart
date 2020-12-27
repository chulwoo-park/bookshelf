import 'dart:convert';

import 'package:bookshelf/common/model/page.dart';
import 'package:bookshelf/feature/book/data/data_source.dart';
import 'package:bookshelf/feature/book/domain/model.dart';
import 'package:bookshelf/http/exception.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import 'model.dart';

SearchResponseVo _convertSearchResponse(Map<String, dynamic> json) {
  try {
    final error = json['error'];
    int total;
    int page;
    List<BookVo> books;
    if (error == '0') {
      total = int.tryParse(json['total'] ?? 'null');
      page = int.tryParse(json['page'] ?? 'null');
      books = (json['books'] as List).map((e) {
        return BookVo(
          title: e['title'],
          subtitle: e['subtitle'],
          isbn13: e['isbn13'],
          price: e['price'],
          image: e['image'],
          url: e['url'],
        );
      }).toList();
    }

    return SearchResponseVo(
      error,
      total,
      page,
      books,
    );
  } catch (e) {
    throw ParsingException(e);
  }
}

BookDetailResponseVo _convertBookDetailResponse(Map<String, dynamic> json) {
  try {
    final error = json['error'];
    if (error != '0') {
      return BookDetailResponseVo(error: error);
    } else {
      return BookDetailResponseVo(
        error: error,
        title: json['title'],
        subtitle: json['subtitle'],
        authors: json['authors'],
        publisher: json['publisher'],
        isbn10: json['isbn10'],
        isbn13: json['isbn13'],
        pages: json['pages'],
        year: json['year'],
        rating: json['rating'],
        desc: json['desc'],
        price: json['price'],
        image: json['image'],
        url: json['url'],
        pdf: json['pdf'],
      );
    }
  } catch (e) {
    throw ParsingException(e);
  }
}

class BookApi implements RemoteBookSource {
  BookApi({Client client}) : this.client = client ?? Client();

  static const baseUrl = 'https://api.itbook.store';

  final Client client;

  @override
  Future<Page<Book>> find(String query, {int page = 1}) {
    var path = '$baseUrl/1.0/search/$query';
    if (page != null) {
      path += '/$page';
    }

    return client.get(path).then((response) async {
      final json = await compute(jsonDecode, response.body);

      final searchResponse = _convertSearchResponse(json);

      if (searchResponse.isSuccess) {
        return Page(
          page: page,
          totalCount: searchResponse.total,
          items: searchResponse.books
              .map(
                (e) => Book(
                  e.title,
                  e.subtitle,
                  e.isbn13,
                  double.tryParse(e.price?.replaceAll('\$', '') ?? 'null'),
                  e.image,
                  e.url,
                ),
              )
              .toList(),
        );
      } else {
        throw RequestFailure(searchResponse.error);
      }
    });
  }

  @override
  Future<BookDetail> getDetail(String isbn13) {
    var path = '$baseUrl/1.0/books/$isbn13';
    return client.get(path).then((response) async {
      final json = await compute(jsonDecode, response.body);

      final detailResponse = _convertBookDetailResponse(json);

      if (detailResponse.isSuccess) {
        Map pdfMap;
        if (json.containsKey('pdf')) {
          pdfMap = json['pdf'];
        } else {
          pdfMap = {};
        }
        return BookDetail(
          detailResponse.title,
          detailResponse.subtitle,
          detailResponse.authors,
          detailResponse.publisher,
          detailResponse.isbn10,
          detailResponse.isbn13,
          int.tryParse(detailResponse.pages ?? 'null'),
          int.tryParse(detailResponse.year ?? 'null'),
          double.tryParse(detailResponse.rating ?? 'null'),
          detailResponse.desc,
          double.tryParse(detailResponse.price?.replaceAll('\$', '') ?? 'null'),
          detailResponse.image,
          detailResponse.url,
          pdfMap.keys.map((title) => Pdf(title, pdfMap[title])).toList(),
        );
      } else {
        throw RequestFailure(detailResponse.error);
      }
    });
  }
}
