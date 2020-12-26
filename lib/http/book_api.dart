import 'dart:convert';

import 'package:bookshelf/feature/book/data/data_source.dart';
import 'package:bookshelf/feature/book/domain/model.dart';
import 'package:bookshelf/http/exception.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import 'model.dart';

class BookApi implements RemoteBookSource {
  BookApi({Client client}) : this.client = client ?? Client();

  static const baseUrl = 'https://api.itbook.store';

  final Client client;

  @override
  Future<List<Book>> find(String query, {int page = 1}) {
    var path = '$baseUrl/1.0/search/$query';
    if (page != null) {
      path += '/$page';
    }

    return client.get(path).then((response) async {
      final json = await compute(jsonDecode, response.body);

      final searchResponse = _convertSearchResponse(json);

      if (searchResponse.isSuccess) {
        return searchResponse.books
            .map(
              (e) => Book(
                e.title,
                e.subtitle,
                e.isbn13,
                double.tryParse(e.price.replaceAll('\$', '')),
                e.image,
                e.url,
              ),
            )
            .toList();
      } else {
        throw RequestFailure(searchResponse.error);
      }
    });
  }

  SearchResponseVo _convertSearchResponse(Map<String, dynamic> json) {
    try {
      final error = json['error'];
      int total;
      int page;
      List<BookVo> books;
      if (error == '0') {
        total = int.tryParse(json['total']);
        page = int.tryParse(json['page']);
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
}
