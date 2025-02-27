import 'package:books/presentation_layer/book_favorites_bloc/favorites_bloc.dart';
import 'package:books/presentation_layer/book_favorites_bloc/favorites_event.dart';
import 'package:books/presentation_layer/books_bloc/books_bloc.dart';
import 'package:books/presentation_layer/books_bloc/books_events.dart';
import 'package:books/presentation_layer/screens/favorites_screen.dart';
import 'package:books/presentation_layer/screens/home_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';

import 'data_layer/books_repo.dart';
import 'domain_layer/books_favorites_model.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter(); // Initialize Hive
  Hive.registerAdapter(BooksFavoritesModelAdapter());
  await Hive.openBox<BooksFavoritesModel>('booksFavoritesBox');
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => BooksBloc(repository: BooksRepositoryImpl(dio: Dio()))..add(FetchBooks())),
        BlocProvider(create: (context) => FavoritesBooksBloc(Hive.box<BooksFavoritesModel>('booksFavoritesBox'))..add(GetFavorites())),
      ],
      child: MyApp(),
    ),
  );

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return   MaterialApp(
      title: 'Flutter Demo',
      home: HomePage(),
    );
  }
}

