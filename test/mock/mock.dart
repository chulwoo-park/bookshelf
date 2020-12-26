import 'package:bookshelf/feature/book/data/data_source.dart';
import 'package:bookshelf/feature/book/domain/repository.dart';
import 'package:bookshelf/feature/book/domain/usecase.dart';
import 'package:mockito/mockito.dart';

class MockSearchUseCase extends Mock implements SearchUseCase {}

class MockBookRepository extends Mock implements BookRepository {}

class MockLocalBookSource extends Mock implements LocalBookSource {}

class MockRemoteBookSource extends Mock implements RemoteBookSource {}
