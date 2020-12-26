import 'package:bookshelf/di/service_locator.dart';
import 'package:bookshelf/feature/book/domain/usecase.dart';
import 'package:bookshelf/memory/book_data_source.dart';
import 'package:flutter/material.dart';

import 'feature/book/data/repository.dart';
import 'screen/main/home.dart';

void main() {
  final bookRepository = BookRepositoryImpl(
    MemoryLocalBookSource(),
    MemoryRemoteBookSource(),
  );

  final search = SearchUseCase(bookRepository);

  runApp(
    ServiceLocator(
      dependencies: Dependencies(
        child: BookshelfApp(),
        search: search,
      ),
    ),
  );
}

class BookshelfApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bookshelf',
      theme: _createTheme(Brightness.light),
      darkTheme: _createTheme(Brightness.dark),
      home: HomeScreen(),
    );
  }

  ThemeData _createTheme(Brightness brightness) {
    ThemeData baseTheme;
    Color textColor;
    if (brightness == Brightness.light) {
      baseTheme = ThemeData.light();
      textColor = Colors.black;
    } else {
      baseTheme = ThemeData.dark();
      textColor = Colors.white;
    }
    return baseTheme.copyWith(
      appBarTheme: AppBarTheme(
        color: Colors.transparent,
        elevation: 0.0,
        brightness: brightness,
        textTheme: TextTheme(
          headline6: TextStyle(
            fontSize: 20.0,
            letterSpacing: 0.15,
            fontWeight: FontWeight.bold,
          ),
        ).apply(
          displayColor: textColor,
          bodyColor: textColor,
        ),
      ),
    );
  }
}
