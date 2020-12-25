import 'package:bookshelf/feature/book/data/data_source.dart';
import 'package:bookshelf/feature/book/domain/repository.dart';
import 'package:mockito/mockito.dart';

class MockBookRepository extends Mock implements BookRepository {}

class MockLocalBookSource extends Mock implements LocalBookSource {}

class MockRemoteBookSource extends Mock implements RemoteBookSource {}
