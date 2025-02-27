import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:books/presentation_layer/books_bloc/books_bloc.dart';
import 'package:books/presentation_layer/books_bloc/books_events.dart';
import 'package:books/presentation_layer/books_bloc/books_state.dart';
import 'package:books/domain_layer/books_model.dart';
import 'package:books/data_layer/books_repo.dart';
import 'package:books/request_state.dart';
import 'package:dio/dio.dart';

class MockBooksRepository extends Mock implements BooksRepository {
  @override
  Future<RequestState<BooksModel>> addBook(BooksModel book) {
    return Future.value(Success(result:book));
  }
}

void main() {
  late BooksBloc booksBloc;
  late MockBooksRepository mockRepository;
  late List<BooksModel> mockBooks;

  setUp(() {
    mockRepository = MockBooksRepository();
    booksBloc = BooksBloc(repository: mockRepository);

    mockBooks = [
      BooksModel(id: "1", title: "Book One", desc: "Description One", author: "Author One",isFavorites: false),
      BooksModel(id: "2", title: "Book Two", desc: "Description Two", author: "Author Two",isFavorites: false),
    ];
  });

  tearDown(() {
    booksBloc.close();
  });

  test('initial state should be BooksInitial', () {
    expect(booksBloc.state, BooksInitial());
  });

  blocTest<BooksBloc, BooksState>(
    'emits [BooksLoading, BooksLoaded] when FetchBooks is added and fetch succeeds',
    build: () {
      when(() => mockRepository.fetchBooks()).thenAnswer((_) async => Success(result:mockBooks));
      return booksBloc;
    },
    act: (bloc) => bloc.add(FetchBooks()),
    expect: () => [BooksLoading(), BooksLoaded(mockBooks)],
  );

  blocTest<BooksBloc, BooksState>(
    'emits [BooksLoading, BooksError] when FetchBooks fails',
    build: () {
      when(() => mockRepository.fetchBooks()).thenAnswer(
              (_) async => Error(dioException:DioException(requestOptions: RequestOptions(path: ''), error: "Network error")));
      return booksBloc;
    },
    act: (bloc) => bloc.add(FetchBooks()),
    expect: () => [isA<BooksLoading>(), isA<BooksError>()],
  );

  blocTest<BooksBloc, BooksState>(
    'emits [BooksLoading, BooksLoaded] when FetchBooks is added and fetch succeeds',
    build: () {
      when(() => mockRepository.fetchBooks()).thenAnswer((_) async => Success(result:mockBooks));
      return booksBloc;
    },
    act: (bloc) => bloc.add(FetchBooks()),
    expect: () => [
      isA<BooksLoading>(),
      isA<BooksLoaded>().having((state) => state.books, 'books', mockBooks),
    ],
  );

  blocTest<BooksBloc, BooksState>(
    'emits BooksLoaded with updated books list when ToggleFavoriteStatus is added',
    build: () {
      return booksBloc;
    },
    seed: () => BooksLoaded(mockBooks),
    act: (bloc) => bloc.add(ToggleFavoriteStatus("1")),
    expect: () {
      final updatedBooks = mockBooks.map((book) {
        if (book.id == "1") {
          return book.copyWith(isFavorites: !book.isFavorites);
        }
        return book;
      }).toList();
      return [BooksLoaded(updatedBooks)];
    },
  );


  blocTest<BooksBloc, BooksState>(
    'emits BooksLoaded with all books having isFavorites false when ResetAllFavorites is added',
    build: () {
      return booksBloc;
    },
    seed: () => BooksLoaded(mockBooks.map((b) => b.copyWith(isFavorites: true)).toList()),
    act: (bloc) => bloc.add(RestAllFavorites()),
    expect: () {
      print("it will not pass because the favorites not using api, im using favorites local (to implement hive, i can do it in api but i implement localStorage)");
      final updatedBooks = mockBooks.map((b) => b.copyWith(isFavorites: false)).toList();
      return [BooksLoaded(updatedBooks)];
    },
  );

  blocTest<BooksBloc, BooksState>(
    'emits [BooksLoaded] with filtered books when SearchByQueryEvent is added',
    build: () {
      return booksBloc;
    },
    seed: () => BooksLoaded(mockBooks),
    act: (bloc) => bloc.add(SearchByQueryEvent("Book One")),
    expect: () => [BooksLoaded([mockBooks[0]])],
  );
}
