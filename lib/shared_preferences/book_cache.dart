import 'dart:convert';

import 'package:bookshelf/common/exception/exceptions.dart';
import 'package:bookshelf/feature/book/data/data_source.dart';
import 'package:bookshelf/feature/book/domain/model.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookCache extends LocalBookSource {
  @override
  Future<List<Book>> getList(String key) {
    return SharedPreferences.getInstance().then(
      (pref) {
        if (!pref.containsKey(key)) {
          throw CacheMissException();
        }

        return Future.wait(pref.getStringList(key).map(_convertToEntity));
      },
      onError: (e) => CacheMissException(),
    );
  }

  @override
  Future<void> saveList(String key, List<Book> data) {
    return SharedPreferences.getInstance().then(
      (pref) async => pref.setStringList(
        key,
        await Future.wait(data.map(_convertToJsonString)),
      ),
    );
  }

  Future<String> _convertToJsonString(Book book) async {
    return compute(
      jsonEncode,
      {
        'title': book.title,
        'subtitle': book.subtitle,
        'isbn13': book.isbn13,
        'price': book.price,
        'image': book.image,
        'url': book.url,
      },
    );
  }

  Future<Book> _convertToEntity(String jsonString) async {
    final json = await compute(jsonDecode, jsonString);
    return Book(
      json['title'],
      json['subtitle'],
      json['isbn13'],
      json['price'],
      json['image'],
      json['url'],
    );
  }
}
