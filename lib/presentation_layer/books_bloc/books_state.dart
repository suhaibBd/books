import 'package:dio/dio.dart';

import '../../domain_layer/books_model.dart';

sealed class BooksState {}

class BooksInitial extends BooksState {}

class BooksLoading extends BooksState {}

class BooksLoaded extends BooksState {
  final List<BooksModel> books;
  final bool isEditing;

  BooksLoaded(this.books, {this.isEditing = false});

  BooksLoaded copyWith({List<BooksModel>? books, bool? isEditing}) {
    return BooksLoaded(
      books ?? this.books,
      isEditing: isEditing ?? this.isEditing,
    );
  }
}


class BooksAdded extends BooksState {
  final BooksModel post;
  BooksAdded(this.post);
}

class BooksEdited extends BooksState {
  final BooksModel post;
  BooksEdited(this.post);
}

class BooksError extends BooksState {
  final DioException error;
  BooksError(this.error);
}
class StartEditing extends BooksState {
  final bool isEditing;
  StartEditing(this.isEditing);
}
class EndEditing extends BooksState {
}


