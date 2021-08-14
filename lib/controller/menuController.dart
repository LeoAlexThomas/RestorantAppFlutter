import 'package:get/get.dart';
import 'package:restorantapp/models/menuItems.dart';

class MenuItemController extends GetxController {
  Map<String, List<DishItems>> menuitems = {};

  static MenuItemController get to => Get.find<MenuItemController>();

  add(String dishCat, List<DishItems> items) {
    menuitems[dishCat] = items;
    update();
  }

  removeItem(String dishCat, DishItems item) {
    menuitems[dishCat]!.remove(item);
    update();
  }
}
