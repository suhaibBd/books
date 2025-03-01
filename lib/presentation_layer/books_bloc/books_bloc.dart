import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data_layer/books_repo.dart';
import '../../domain_layer/books_model.dart';
import '../../request_state.dart';
import 'books_events.dart';
import 'books_state.dart';

class BooksBloc extends Bloc<BooksEvent, BooksState> {
  final BooksRepository repository;
 List<BooksModel> books = [];
  BooksBloc({required this.repository}) : super(BooksInitial()) {
    on<FetchBooks>((event, emit) async {
      emit(BooksLoading());

      final result = await repository.fetchBooks();
      if (result is Success<List<BooksModel>>) {
        emit(BooksLoaded(result.result ?? []));
        books = result.result!;
      } else if (result is Error<List<BooksModel>>) {
        emit(BooksError(result.dioException));
      }
    });

    on<EditBook>((event, emit) async {

      final result = await repository.editBook(event.book);
      if (result is Success<BooksModel>) {
        emit(BooksEdited(event.book));
        add(FetchBooks());

      } else if (result is Error<BooksModel>) {
        print("no edit no edot");

        emit(BooksError(result.dioException));
      }
    });

    on<ToggleFavoriteStatus>((event, emit) {
      if (state is BooksLoaded) {
        final loadedState = state as BooksLoaded;
        final updatedBooks = loadedState.books.map((book) {
          print("toggleed${book.id == event.bookId}");

          if (book.id == event.bookId) {
            return book.copyWith(isFavorites: !(book.isFavorites ?? false));
          }
          return book;
        }).toList();

        emit(BooksLoaded(updatedBooks));
      }
    });
on<RestAllFavorites>((event,emit){
  final loadedState = state as BooksLoaded;
  final updatedBooks = loadedState.books.map((book) {


      return book.copyWith(isFavorites:  false);
    }).toList();
  emit(BooksLoaded(updatedBooks));
});


    on<AddNewBookEvent>((event, emit) async {
      emit(BooksLoading());
try {
  final result = await repository.addBook(event.newBook);
  if (result is Success<BooksModel>) {
emit(BooksAdded());
    add(FetchBooks());
  }
  else if (result is Error<BooksModel>) {
    emit(BooksError(result.dioException));
  }
}
catch (dioException)
      {
        if ( dioException is DioException) {
          emit(BooksError(dioException));
        }

      }
    });

    on<SearchByQueryEvent>((event, emit) {
        List<BooksModel> results = [];
        if (event.keyWordSearchQuery!.isEmpty) {
          results = books;
        } else {
          results = books.where((book) {
            final lowerCaseQuery = event.keyWordSearchQuery!.toLowerCase();
            return (book.title!.toLowerCase().contains(lowerCaseQuery)) ||
                (book.author!.toLowerCase().contains(lowerCaseQuery));
          }).toList();
        }


         emit(BooksLoaded(results));
    });

    on<StartEditBookInfo>((event, emit) {
      if (state is BooksLoaded) {
        final currentState = state as BooksLoaded;
        emit(currentState.copyWith(isEditing: event.isEditingMode));
      }
    });

  }


  }


