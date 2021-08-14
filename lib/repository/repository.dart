import 'package:dio/dio.dart';
import 'package:restorantapp/api/api.dart';
import 'package:restorantapp/api/client.dart';
import 'package:restorantapp/models/restorant.dart';

class Repository {
  late Dio apiClient;

  Repository() {
    apiClient = client();
  }

  Future<List<RestorantInfo>> fetchAll() async {
    Response response = await fetchall(apiClient);
    return List<RestorantInfo>.from(
        (response.data).map((json) => RestorantInfo.fromJson(json)));
  }
}
