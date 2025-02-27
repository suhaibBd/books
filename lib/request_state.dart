import 'package:dio/dio.dart';
sealed class RequestState<T>
{
  const RequestState();
}
class Success<T> extends RequestState<T>
{
  final T? result;
  const Success({this.result});
}
class Error<T> extends RequestState<T>
{
  final DioException dioException;
  const Error({required this.dioException});
}
