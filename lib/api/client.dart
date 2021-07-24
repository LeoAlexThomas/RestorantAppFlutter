import 'package:dio/dio.dart';

Dio client() {
  Dio dio = new Dio();
  dio.options.baseUrl = "https://www.mocky.io/v2/5dfccffc310000efc8d2c1ad";
  dio.options.connectTimeout = 10000; // milliseconds
  return dio;
}
