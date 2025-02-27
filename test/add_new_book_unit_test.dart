import 'package:bloc_test/bloc_test.dart';
import 'package:books/data_layer/books_repo.dart';
import 'package:books/domain_layer/books_model.dart';
import 'package:books/presentation_layer/books_bloc/books_bloc.dart';
import 'package:books/presentation_layer/books_bloc/books_events.dart';
import 'package:books/presentation_layer/books_bloc/books_state.dart';
import 'package:books/request_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBooksRepository extends Mock implements BooksRepository {}

void main() {
  late BooksBloc booksBloc;
  late MockBooksRepository mockBooksRepository;

  setUp(() {
    mockBooksRepository = MockBooksRepository();
    booksBloc = BooksBloc(repository: mockBooksRepository);
    registerFallbackValue((BooksModel(
      title: 'Test Title',
      desc: 'Test Description',
      author: 'Test Author',
      publicationDate: '2025-02-28',
    )));

  });

  tearDown(() {
    booksBloc.close();
  });

  group('BooksBloc', () {
    test('initial state is BooksInitial', () {
      expect(booksBloc.state, equals(BooksInitial()));
    });

    blocTest<BooksBloc, BooksState>(
      'emits BooksLoading and then BooksLoaded when AddNewBookEvent is added',
      build: () {
        when(() => mockBooksRepository.addBook(any()))
            .thenAnswer((_) async => Success(result: BooksModel(
          title: 'Test Title',
          desc: 'Test Description',
          author: 'Test Author',
          publicationDate: '2025-02-28',
        )));

        when(() => mockBooksRepository.fetchBooks())
            .thenAnswer((_) async => const Success(result: []));

        return booksBloc;
      },
      act: (bloc) {
        bloc.add(AddNewBookEvent(BooksModel(
          title: 'Test Title',
          desc: 'Test Description',
          author: 'Test Author',
          publicationDate: '2025-02-28',
        )));
      },
      expect: () => [
        BooksLoading(),
        BooksLoaded([]),
      ],
      verify: (_) {
        verify(() => mockBooksRepository.addBook(any())).called(1);
        verify(() => mockBooksRepository.fetchBooks()).called(1);
      },
    );


    blocTest<BooksBloc, BooksState>(
      'emits BooksError when AddNewBookEvent fails',
      build: () {
        // Simulate the repository returning an error response
        when(() => mockBooksRepository.addBook(any())).thenAnswer(
              (_) async => Error<BooksModel>(
            dioException: DioException(
              error: 'Failed to add book',
              requestOptions: RequestOptions(path: '/books'),
            ),
          ),
        );
        return booksBloc;
      },
      act: (bloc) {
        // Add the AddNewBookEvent to the bloc
        bloc.add(AddNewBookEvent(BooksModel(
          title: 'Test Title',
          desc: 'Test Description',
          author: 'Test Author',
          publicationDate: '2025-02-28',
        )));
      },
      expect: () => [
        BooksLoading(), // Expect BooksLoading first
        isA<BooksError>() // Expect BooksError with the correct DioException
            .having((e) => e.error.error, 'error', 'Failed to add book') // Match the error message inside DioException
      ],
      verify: (_) {
        // Verify that the addBook method was called once
        verify(() => mockBooksRepository.addBook(any())).called(1);
      },
    );





    blocTest<BooksBloc, BooksState>(
      'emits BooksLoaded with books when fetching books',
      build: () {
        when(() => mockBooksRepository.fetchBooks()).thenAnswer(
              (_) async => Success(result:
              [
                BooksModel(
                  title: 'Test Book 1',
                  desc: 'Description 1',
                  author: 'Author 1',
                  publicationDate: '2025-02-28',
                ),
                BooksModel(
                  title: 'Test Book 2',
                  desc: 'Description 2',
                  author: 'Author 2',
                  publicationDate: '2025-03-01',
                ),
              ]

              ),
        );
        return booksBloc;
      },
      act: (bloc) {
        bloc.add(FetchBooks());
      },
      expect: () => [
        BooksLoading(),
        BooksLoaded([
          BooksModel(
            title: 'Test Book 1',
            desc: 'Description 1',
            author: 'Author 1',
            publicationDate: '2025-02-28',
          ),
          BooksModel(
            title: 'Test Book 2',
            desc: 'Description 2',
            author: 'Author 2',
            publicationDate: '2025-03-01',
          ),
        ]),
      ],
    );
  });
}
