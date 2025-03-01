import 'package:books/presentation_layer/screens/book_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../books_bloc/books_bloc.dart';
import '../books_bloc/books_events.dart';
import '../books_bloc/books_state.dart';
import 'add_new_book_screen.dart';
import 'favorites_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();

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
              child: const Icon(Icons.star,color: Colors.white,)
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 5),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search by title or author",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (query) {
                context.read<BooksBloc>().add(SearchByQueryEvent(query));
              },
            ),
          ),
        ),
      ),
      body: BlocBuilder<BooksBloc, BooksState>(
        builder: (context, state) {
          if (state is BooksLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BooksLoaded) {
            return Column(
              children: [

                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: state.books.length,
                    itemBuilder: (context, index) {
                      final book = state.books[index];
                      return Card(
                        child: ListTile(
                          title: Text(book.title!),
                          subtitle: Text(book.desc!),
                          trailing: Text(book.author!),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => BookDetailsScreen(bookId: book.id!),
                            ));
                          },
                        ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {

        },
        child: IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddNewBookScreen(),
              ));
            },
            icon: const Icon(Icons.add_outlined,color: Colors.white,)
        ),
      ),
    );
  }
}