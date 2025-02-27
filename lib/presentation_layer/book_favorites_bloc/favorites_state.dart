import '../../domain_layer/books_favorites_model.dart';
import '../../domain_layer/books_model.dart';

abstract class BooksState {}

class BooksInitial extends BooksState {}

class FavoritesLoaded extends BooksState {
  final List<BooksFavoritesModel> favorites;

  FavoritesLoaded(this.favorites);
}

class FavoritesError extends BooksState {
  final String message;

  FavoritesError(this.message);
}
