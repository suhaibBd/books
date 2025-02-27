import 'package:books/presentation_layer/screens/book_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../books_bloc/books_bloc.dart';
import '../books_bloc/books_events.dart';
import '../books_bloc/books_state.dart';
import 'add_new_book_screen.dart';
import 'favorites_screen.dart';

class HomePage extends StatelessWidget {
  SearchController searchController = SearchController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Books'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => FavoriteBooksScreen(),
                ));
              },
              child: const Text(
                "Favorites",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddNewBookScreen(),
                ));
              },
              child: const Text(
                "Add New Book",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<BooksBloc, BooksState>(
        builder: (context, state) {
          if (state is BooksLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BooksLoaded) {
            return Column(
              children: [
                SearchBar(
                  controller: searchController,
                  hintText: "Search by title or author",
                  onChanged: (query) {
                    context.read<BooksBloc>().add(SearchByQueryEvent(query));
                  },
                ),
                // Wrap the ListView with Expanded to ensure it gets the available space
                Expanded(
                  child: ListView.builder(
                    itemCount: state.books.length,
                    itemBuilder: (context, index) {
                      final book = state.books[index];
                      return ListTile(
                        title: Text(book.title!),
                        subtitle: Text(book.desc!),
                        trailing: Text(book.author!),
                        // trailing: IconButton(
                        //   icon: ,
                        //   onPressed: () {
                        //     context.read<BooksBloc>().add(ToggleFavoriteStatus(book.id!));
                        //     if (book.isFavorites == true) {
                        //       context.read<FavoritesBooksBloc>().add(RemoveFromFavorites(book.id!));
                        //     } else {
                        //       context.read<FavoritesBooksBloc>().add(AddToFavorites(BooksFavoritesModel(
                        //         title: book.title,
                        //         desc: book.desc,
                        //         id: book.id,
                        //         author: book.author,
                        //       )));
                        //     }
                        //   },
                        // ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => BookDetailsScreen(bookId: book.id!),
                          ));
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (state is BooksError) {
            return Center(child: Text('Error: ${state.error.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}



