class DishItems {
  final String dishId;
  final String dishName;
  final double dishPrice;
  final int dishCal;
  final String dishDesc;
  late int dishCount;
  final bool addOnCat;
  final String dishImage;
  late bool addToCart;
  DishItems(
    this.dishId,
    this.dishName,
    this.dishPrice,
    this.dishCal,
    this.dishCount,
    this.dishDesc,
    this.addOnCat,
    this.dishImage,
    this.addToCart,
  );
}
