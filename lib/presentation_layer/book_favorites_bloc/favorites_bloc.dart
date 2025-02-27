import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../../domain_layer/books_favorites_model.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBooksBloc extends Bloc<BooksEvent, BooksState> {
  final Box<BooksFavoritesModel> booksFavoritesBox;

  FavoritesBooksBloc(this.booksFavoritesBox) : super(BooksInitial()) {

    on<AddToFavorites>((event, emit) async {
      await booksFavoritesBox.add(event.book);
      emit(FavoritesLoaded(booksFavoritesBox.values.toList()));
    });

    on<GetFavorites>((event, emit) {
      emit(FavoritesLoaded(booksFavoritesBox.values.toList()));
    });
    on<RemoveFromFavorites>((event, emit) async {
      final bookKey = booksFavoritesBox.keys.firstWhere(
            (key) => booksFavoritesBox.get(key)?.id == event.bookId,
        orElse: () => null,
      );

      if (bookKey != null) {
        await booksFavoritesBox.delete(bookKey);
        emit(FavoritesLoaded(booksFavoritesBox.values.toList()));
      }
    });


    on<ClearFavorites>((event, emit) async {
      await booksFavoritesBox.clear();
      emit(FavoritesLoaded([]));
    });
  }
}

