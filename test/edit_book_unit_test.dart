import 'package:bloc_test/bloc_test.dart';
import 'package:books/data_layer/books_repo.dart';
import 'package:books/domain_layer/books_model.dart';
import 'package:books/presentation_layer/books_bloc/books_bloc.dart';
import 'package:books/presentation_layer/books_bloc/books_events.dart';
import 'package:books/presentation_layer/books_bloc/books_state.dart';
import 'package:books/request_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBooksRepository extends Mock implements BooksRepository {}

void main() {
  late BooksBloc booksBloc;
  late MockBooksRepository mockBooksRepository;
  late BooksModel testBook;

  setUp(() {
    mockBooksRepository = MockBooksRepository();
    booksBloc = BooksBloc(repository: mockBooksRepository);

    testBook = BooksModel(
      id: '1',
      title: 'Old Title',
      desc: 'Old Description',
      author: 'Old Author',
      publicationDate: '2025-02-28',
    );

    registerFallbackValue(testBook);

    when(() => mockBooksRepository.fetchBooks())
        .thenAnswer((_) async => const Success(result: []));
  });

  tearDown(() {
    booksBloc.close();
  });

  blocTest<BooksBloc, BooksState>(
    'emits [BooksLoading, BooksEdited] when EditBook event is added',
    build: () {
      when(() => mockBooksRepository.editBook(any())).thenAnswer((_) async =>
          Success(result: testBook.copyWith(
            title: 'New Title',
            desc: 'New Description',
            author: 'New Author',
          )));
      return booksBloc;
    },
    act: (bloc) => bloc.add(EditBook(testBook.copyWith(
      title: 'New Title',
      desc: 'New Description',
      author: 'New Author',
    ))),
    expect: () => [
      BooksLoading(),
      BooksEdited(
        testBook.copyWith(
          title: 'New Title',
          desc: 'New Description',
          author: 'New Author',
        ),
      ),
      BooksLoading(),

    ],
    verify: (_) {
      verify(() => mockBooksRepository.editBook(any())).called(1);
    },
  );
}
