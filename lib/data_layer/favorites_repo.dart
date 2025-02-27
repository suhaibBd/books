import 'package:hive/hive.dart';

import '../domain_layer/books_model.dart';

class BooksRepository {
  final Box<BooksModel> favoritesBox;

  BooksRepository(this.favoritesBox);

  Future<void> addToFavorites(BooksModel book) async {
    await favoritesBox.add(book);
  }

  List<BooksModel> getFavorites() {
    return favoritesBox.values.toList();
  }
}
