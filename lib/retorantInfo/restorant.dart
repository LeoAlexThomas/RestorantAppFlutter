class RestorantInfo {
  late String restaurant_name;
  late String restaurant_image;
  var table_menu_list;
  RestorantInfo(
      {required this.restaurant_name,
      required this.restaurant_image,
      this.table_menu_list});

  RestorantInfo.fromJson(Map<String, dynamic> json) {
    restaurant_name = json['restaurant_name'];
    restaurant_image = json['restaurant_image'];
    table_menu_list = json['table_menu_list'];
  }
}
