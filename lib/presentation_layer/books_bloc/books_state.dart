import 'package:dio/dio.dart';

import '../../domain_layer/books_model.dart';
import 'package:equatable/equatable.dart';

sealed class BooksState extends Equatable {}

class BooksInitial extends BooksState {

  @override
  List<Object?> get props => [];
}

class BooksLoading extends BooksState {
  @override
  List<Object?> get props => [];
}

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

  @override
  List<Object?> get props => [books, isEditing];
}

class BooksAdded extends BooksState {

  BooksAdded();

  @override
  List<Object?> get props => [];
}

class BooksEdited extends BooksState {
  final BooksModel post;

  BooksEdited(this.post);

  @override
  List<Object?> get props => [post];
}

class BooksError extends BooksState {
  final DioException error;

  BooksError(this.error);

  @override
  List<Object?> get props => [error];
}

class StartEditing extends BooksState {
  final bool isEditing;

  StartEditing(this.isEditing);

  @override
  List<Object?> get props => [isEditing];
}

class PreviewMode extends BooksState {
  @override
  List<Object?> get props => [];
}

class EditingMode extends BooksState {
  @override
  List<Object?> get props => [];
}


