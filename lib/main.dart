import 'package:bookshelf/di/service_locator.dart';
import 'package:bookshelf/feature/book/domain/usecase.dart';
import 'package:bookshelf/feature/book/presentation/bloc.dart';
import 'package:bookshelf/feature/note/data/repository.dart';
import 'package:bookshelf/feature/note/domain/usecase.dart';
import 'package:bookshelf/http/book_api.dart';
import 'package:bookshelf/shared_preferences/book_cache.dart';
import 'package:bookshelf/shared_preferences/persistent_note.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'feature/book/data/repository.dart';
import 'ui/home/home.dart';

void main() {
  final bookRepository = BookRepositoryImpl(
    BookCache(),
    BookApi(),
  );

  final noteRepository = NoteRepositoryImpl(
    PersistentNote(),
  );

  final search = SearchUseCase(bookRepository);
  final getDetail = GetDetailUseCase(bookRepository);
  final addNote = AddNoteUseCase(noteRepository);
  final getNotes = GetNotesUseCase(noteRepository);

  runApp(
    ServiceLocator(
      dependencies: Dependencies(
        child: BookshelfApp(),
        search: search,
        getDetail: getDetail,
        addNote: addNote,
        getNotes: getNotes,
      ),
    ),
  );
}

class BookshelfApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final search = ServiceLocator.of(context).search;
    return MaterialApp(
      title: 'Bookshelf',
      theme: _createTheme(Brightness.light),
      darkTheme: _createTheme(Brightness.dark),
      home: BlocProvider(
        create: (context) => BookListBloc(search),
        child: HomeScreen(),
      ),
    );
  }

  ThemeData _createTheme(Brightness brightness) {
    ThemeData baseTheme;
    Color primaryColor;
    Color cursorColor;
    Color textColor;
    if (brightness == Brightness.light) {
      baseTheme = ThemeData.light();
      primaryColor = Color(0xff333333);
      cursorColor = primaryColor;
      textColor = Colors.black;
    } else {
      baseTheme = ThemeData.dark();
      primaryColor = Colors.white;
      cursorColor = Color(0xffeeeeee);
      textColor = Colors.white;
    }
    return baseTheme.copyWith(
      primaryColor: primaryColor,
      appBarTheme: AppBarTheme(
        color: baseTheme.scaffoldBackgroundColor,
        elevation: 0.0,
        brightness: brightness,
        iconTheme: IconThemeData(
          color: primaryColor,
        ),
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
      textSelectionHandleColor: cursorColor,
      textSelectionColor: cursorColor.withOpacity(0.3),
    );
  }
}
