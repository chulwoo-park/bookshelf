import 'dart:convert';

import 'package:bookshelf/common/exception/exceptions.dart';
import 'package:bookshelf/common/model/page.dart';
import 'package:bookshelf/feature/book/data/data_source.dart';
import 'package:bookshelf/feature/book/domain/model.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

Page<Book> _convertToPage(String jsonString) {
  final json = jsonDecode(jsonString);
  return Page(
    page: json['page'],
    totalCount: json['totalCount'],
    items: (json['items'] as List).cast<String>().map((book) {
      final bookJson = jsonDecode(book);
      return Book(
        bookJson['title'],
        bookJson['subtitle'],
        bookJson['isbn13'],
        bookJson['price'],
        bookJson['image'],
        bookJson['url'],
      );
    }).toList(),
  );
}

String _convertPageToJsonString(Page<Book> page) {
  return jsonEncode(
    {
      'page': page.page,
      'totalCount': page.totalCount,
      'items': page
          .map((e) => jsonEncode({
                'title': e.title,
                'subtitle': e.subtitle,
                'isbn13': e.isbn13,
                'price': e.price,
                'image': e.image,
                'url': e.url,
              }))
          .toList(),
    },
  );
}

BookDetail _convertToDetail(String jsonString) {
  final json = jsonDecode(jsonString);
  return BookDetail(
    json['title'],
    json['subtitle'],
    json['authors'],
    json['publisher'],
    json['isbn10'],
    json['isbn13'],
    json['pages'],
    json['year'],
    json['rating'],
    json['desc'],
    json['price'],
    json['image'],
    json['url'],
    json['pdfs'].map<Pdf>((jsonString) {
      final json = jsonDecode(jsonString);
      return Pdf(json['title'], json['url']);
    }).toList(),
  );
}

String _convertDetailToJsonString(BookDetail detail) {
  return jsonEncode(
    {
      'title': detail.title,
      'subtitle': detail.subtitle,
      'authors': detail.authors,
      'publisher': detail.publisher,
      'isbn10': detail.isbn10,
      'isbn13': detail.isbn13,
      'pages': detail.pages,
      'year': detail.year,
      'rating': detail.rating,
      'desc': detail.description,
      'price': detail.price,
      'image': detail.image,
      'url': detail.url,
      'pdfs': detail.pdfs
          .map(
            (pdf) => jsonEncode({
              'title': pdf.title,
              'url': pdf.url,
            }),
          )
          .toList(),
    },
  );
}

class BookCache extends LocalBookSource {
  @override
  Future<Page<Book>> getList(String key) {
    return SharedPreferences.getInstance().then(
      (pref) {
        if (!pref.containsKey(key)) {
          throw CacheMissException();
        }

        return _convertToPage(pref.getString(key));
      },
      onError: (e) {
        throw CacheMissException();
      },
    );
  }

  @override
  Future<void> saveList(String key, Page<Book> data) {
    return SharedPreferences.getInstance().then(
      (pref) async => pref.setString(
        key,
        await compute(_convertPageToJsonString, data),
      ),
    );
  }

  @override
  Future<BookDetail> getDetail(String isbn13) {
    return SharedPreferences.getInstance().then((pref) {
      if (!pref.containsKey(isbn13)) {
        throw CacheMissException();
      }

      return _convertToDetail(pref.getString(isbn13));
    });
  }

  @override
  Future<void> saveDetail(String isbn13, BookDetail detail) {
    return SharedPreferences.getInstance().then(
      (pref) async => pref.setString(
        isbn13,
        await compute(_convertDetailToJsonString, detail),
      ),
    );
  }
}
