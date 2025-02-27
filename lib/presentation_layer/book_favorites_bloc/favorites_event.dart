import '../../domain_layer/books_favorites_model.dart';
import '../../domain_layer/books_model.dart';

abstract class BooksEvent {}

class AddToFavorites extends BooksEvent {
  final BooksFavoritesModel book;

  AddToFavorites(this.book);
}

class GetFavorites extends BooksEvent {}

class RemoveFromFavorites extends BooksEvent {
  final String bookId;
  RemoveFromFavorites(this.bookId);
}

class ClearFavorites extends BooksEvent {}