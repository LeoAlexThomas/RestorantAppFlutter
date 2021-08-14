import 'package:restorantapp/repository/repository.dart';
import 'package:restorantapp/models/restorant.dart';
import 'package:get/get.dart';

class RestorantController extends GetxController {
  List<RestorantInfo> info = [];
  Repository repository = Repository();

  static RestorantController get to => Get.find<RestorantController>();

  fetchAllRestorantInfo() async {
    info = await repository.fetchAll();
    print('Data: ${info[0]}');
    update();
  }
}
