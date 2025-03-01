import 'package:dio/dio.dart';

import '../domain_layer/books_model.dart';
import '../endpoints.dart';
import '../request_state.dart';

abstract class BooksRepository {
  Future<RequestState<List<BooksModel>>> fetchBooks();
  Future<RequestState<BooksModel>> addBook(BooksModel book);
  Future<RequestState<BooksModel>> editBook(BooksModel book);
}

class BooksRepositoryImpl implements BooksRepository {
  final Dio dio;

  BooksRepositoryImpl({required this.dio});

  @override
  Future<RequestState<List<BooksModel>>> fetchBooks() async {
    try {
      final response = await dio.get(Endpoints.books);
      List<BooksModel> books = (response.data as List)
          .map((json) => BooksModel.fromJson(json))
          .toList();
      return Success(result: books);
    } on DioException catch (e) {
      return Error(dioException: e);
    }
  }

  @override
  Future<RequestState<BooksModel>> addBook(BooksModel book) async {
    try {
      final response = await dio.post(Endpoints.books, data: book.toJson());
      return Success(result: BooksModel.fromJson(response.data));
    } on DioException catch (e) {
      return Error(dioException: e);
    }
  }

  @override
  Future<RequestState<BooksModel>> editBook(BooksModel book) async {
    try {
      final response = await dio.put('${Endpoints.books}/${book.id}', data: book.toJson());
      return Success(result: BooksModel.fromJson(response.data));
    } on DioException catch (e) {
      return Error(dioException: e);
    }
  }
}
