class RestorantInfo {
  late String restaurantName;
  late String restaurantImage;
  var tableMenuList;
  RestorantInfo({
    required this.restaurantName,
    required this.restaurantImage,
    this.tableMenuList,
  });

  RestorantInfo.fromJson(Map<String, dynamic> json) {
    restaurantName = json['restaurant_name'];
    restaurantImage = json['restaurant_image'];
    tableMenuList = json['table_menu_list'];
  }
}
