import 'package:dio/dio.dart';

Future<Response> fetchall(Dio dio) {
  return dio.get('');
}
