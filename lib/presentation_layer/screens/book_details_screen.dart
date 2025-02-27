import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain_layer/books_favorites_model.dart';
import '../book_favorites_bloc/favorites_bloc.dart';
import '../book_favorites_bloc/favorites_event.dart';
import '../books_bloc/books_bloc.dart';
import '../books_bloc/books_events.dart';
import '../books_bloc/books_state.dart' as book_state;
import '../books_bloc/books_state.dart';


class BookDetailsScreen extends StatelessWidget {
  final String bookId;

   BookDetailsScreen({Key? key, required this.bookId}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),
        backgroundColor: Colors.blueAccent,
      ),
      body: BlocBuilder<BooksBloc, book_state.BooksState>(
        builder: (context, state) {
          if (state is BooksLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BooksLoaded) {
            final book = state.books.firstWhere((book) => book.id == bookId);

              _titleController.text = book.title ?? "";
              _descController.text = book.desc ?? "";
              _authorController.text = book.author ?? "";


            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height - 30,
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          book.title ?? "No Title",
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          book.desc ?? "No Description",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Author: ${book.author ?? "Unknown"}",
                          style: const TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          "Published: ${book.publicationDate ?? "Unknown Date"}",
                          style: const TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        const SizedBox(height: 24),
                        Center(
                          child: IconButton(
                            icon: Icon(
                              book.isFavorites == true
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 36,
                              color: book.isFavorites == true ? Colors.red : Colors.black,
                            ),
                            onPressed: () {
                              context.read<BooksBloc>().add(ToggleFavoriteStatus(book.id!));
                              if (book.isFavorites == true) {
                                context.read<FavoritesBooksBloc>().add(RemoveFromFavorites(book.id!));
                              } else {
                                context.read<FavoritesBooksBloc>().add(AddToFavorites(BooksFavoritesModel(
                                  title: book.title,
                                  desc: book.desc,
                                  id: book.id,
                                  author: book.author,
                                )));
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 24),

                    BlocBuilder<BooksBloc, BooksState>(
                      builder: (context, state) {
                        if (state is BooksLoaded) {
                          final book = state.books.firstWhere((book) => book.id == bookId);

                          return Column(
                            children: [
                              if (!state.isEditing)
                                ElevatedButton(
                                  onPressed: () {
                                    context.read<BooksBloc>().add(StartEditBookInfo(true));
                                  },
                                  child: const Text("Edit Book"),
                                )
                               else
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      TextFormField(controller: _titleController, decoration: const InputDecoration(labelText: 'Title')),
                                      TextFormField(controller: _descController, decoration: const InputDecoration(labelText: 'Description')),
                                      TextFormField(controller: _authorController, decoration: const InputDecoration(labelText: 'Author')),
                                      ElevatedButton(
                                        onPressed: () {
                                          if (_formKey.currentState!.validate()) {
                                            context.read<BooksBloc>().add(EditBook(
                                              book.copyWith(
                                                title: _titleController.text,
                                                desc: _descController.text,
                                                author: _authorController.text,
                                              ),
                                            ));
                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Book updated successfully!')));
                                          }
                                        },
                                        child: const Text('Save Changes'),
                                      ),
                                    ],
                                  ),
                                ),

                            ],
                          );
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                    )



                    ],
                    ),
                  ),
                ),
              ),
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
