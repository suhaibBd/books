import 'package:flutter/cupertino.dart';

import '../../domain_layer/books_model.dart';

sealed class BooksEvent {}

class FetchBooks extends BooksEvent {}

class AddBook extends BooksEvent {
  final BooksModel post;
  AddBook(this.post);
}

class EditBook extends BooksEvent {
  final BooksModel post;
  EditBook(this.post);
}
class ToggleFavoriteStatus extends BooksEvent {
  final String bookId;

  ToggleFavoriteStatus(this.bookId) {
    debugPrint("is caaaaled");
  }
}
class RestAllFavorites extends BooksEvent {
  RestAllFavorites();
}

class AddNewBookEvent extends BooksEvent {
  final BooksModel newBook;

  AddNewBookEvent(this.newBook);
}

class SearchByQueryEvent extends BooksEvent {
 String? keyWordSearchQuery;


 SearchByQueryEvent(this.keyWordSearchQuery);

}
class StartEditBookInfo extends BooksEvent {
  bool isEditingMode;


  StartEditBookInfo(this.isEditingMode);

}

