import 'dart:convert';

import 'package:bookshelf/common/exception/exceptions.dart';
import 'package:bookshelf/common/model/page.dart';
import 'package:bookshelf/feature/book/data/data_source.dart';
import 'package:bookshelf/feature/book/domain/model.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

Page<Book> _convertToEntity(String jsonString) {
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

String _convertToJsonString(Page<Book> page) {
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

class BookCache extends LocalBookSource {
  @override
  Future<Page<Book>> getList(String key) {
    return SharedPreferences.getInstance().then(
      (pref) async {
        if (!pref.containsKey(key)) {
          throw CacheMissException();
        }

        final result = _convertToEntity(pref.getString(key));
        return result;
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
        await compute(_convertToJsonString, data),
      ),
    );
  }
}
