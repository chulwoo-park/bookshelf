import 'dart:convert';

import 'package:bookshelf/common/exception/exceptions.dart';
import 'package:bookshelf/feature/book/data/data_source.dart';
import 'package:bookshelf/feature/book/domain/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookCache extends LocalBookSource {
  @override
  Future<List<Book>> getList(String key) {
    return SharedPreferences.getInstance().then(
      (pref) {
        if (!pref.containsKey(key)) {
          throw CacheMissException();
        }

        return pref.getStringList(key).map(_convertToEntity).toList();
      },
      onError: (e) => CacheMissException(),
    );
  }

  @override
  Future<void> saveList(String key, List<Book> data) {
    return SharedPreferences.getInstance().then((pref) =>
        pref.setStringList(key, data.map(_convertToJsonString).toList()));
  }

  String _convertToJsonString(Book book) {
    return jsonEncode(
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

  Book _convertToEntity(String jsonString) {
    final json = jsonDecode(jsonString);
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
