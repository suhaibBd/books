import 'package:books/presentation_layer/books_bloc/books_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../book_favorites_bloc/favorites_bloc.dart';
import '../book_favorites_bloc/favorites_event.dart';
import '../book_favorites_bloc/favorites_state.dart';
import '../books_bloc/books_bloc.dart';

class FavoriteBooksScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites'),actions: [
        IconButton(onPressed: (){
          context.read<FavoritesBooksBloc>().add(ClearFavorites());
          context.read<BooksBloc>().add(RestAllFavorites());


        }, icon: const Icon(Icons.delete))
      ],),
      body: BlocBuilder<FavoritesBooksBloc, BooksState>(
        builder: (context, state) {
          if (state is FavoritesLoaded) {
            return ListView.builder(
              itemCount: state.favorites.length,
              itemBuilder: (context, index) {
                final book = state.favorites[index];
                return ListTile(
                  title: Text(book.title ?? 'No Title'),
                  subtitle: Text(book.author ?? 'No Author'),
                  trailing: Text(book.publicationDate ?? DateTime.now().toString().split(" ").first),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
