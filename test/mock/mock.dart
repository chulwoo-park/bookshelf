import 'package:bookshelf/feature/book/data/source/data_source.dart';
import 'package:bookshelf/feature/book/domain/repository/repository.dart';
import 'package:mockito/mockito.dart';

class MockBookRepository extends Mock implements BookRepository {}

class MockLocalBookSource extends Mock implements LocalBookSource {}

class MockRemoteBookSource extends Mock implements RemoteBookSource {}
