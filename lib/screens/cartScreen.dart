import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:restorantapp/controller/menuController.dart';
import 'package:restorantapp/models/menuItems.dart';
import 'package:restorantapp/screens/home.dart';

class CartScreenAlt extends StatefulWidget {
  final String userName;
  final String uid;
  final String image;
  final Function(String oper, String dishCat, DishItems dish) onChanged;
  CartScreenAlt({
    Key? key,
    required this.onChanged,
    required this.userName,
    required this.uid,
    required this.image,
  }) : super(key: key);

  @override
  _CartScreenAltState createState() => _CartScreenAltState();
}

class _CartScreenAltState extends State<CartScreenAlt> {
  final cartItemController = MenuItemController.to;
  List<String> dishName = [];
  List<DishItems> dishAdded = [];
  int totalItems = 0;
  int totalDish = 0;
  double total = 0;
  var scrWidth;
  var scrHeight;
  var fontHeight;

  @override
  void initState() {
    super.initState();
    cartItemController.menuitems.forEach((key, value) {
      dishName.add(key);
    });
    // print(dishName);
    getCartItems();
    getItemCount();
  }

  getCartItems() {
    cartItemController.menuitems.forEach((key, value) {
      for (var item in value) {
        if (item.addToCart) {
          dishAdded.add(item);
        }
      }
    });
  }

  getItemCount() {
    int items = 0;
    totalDish = dishAdded.length;
    cartItemController.menuitems.forEach((key, value) {
      for (var item in value) {
        if (item.addToCart) {
          items += item.dishCount;
        }
      }
    });
    totalItems = items;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    scrWidth = MediaQuery.of(context).size.width / 100;
    scrHeight = MediaQuery.of(context).size.height / 100;
    fontHeight = MediaQuery.of(context).size.height * 0.01;
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.grey),
        backgroundColor: Colors.white,
        title: Text(
          'Order Summary',
          style: TextStyle(fontSize: fontHeight * 2.5, color: Colors.grey),
        ),
      ),
      body: Column(
        children: [
          Container(
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 1.0,
                  spreadRadius: 2.0,
                  offset: Offset(1.0, 3.0),
                )
              ],
            ),
            margin: EdgeInsets.symmetric(
              vertical: scrHeight * 1.5,
              horizontal: scrWidth * 1.5,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green[900],
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(
                    horizontal: scrWidth * 0.5,
                    vertical: scrHeight * 1.5,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: scrWidth * 1.5,
                    vertical: scrHeight * 1.5,
                  ),
                  child: Center(
                    child: Text(
                      '${dishAdded.length} Dishes - $totalItems Items',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: fontHeight * 2.5,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: scrHeight * 60,
                  child: ListView.separated(
                    itemCount: dishAdded.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider();
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                width: scrWidth * 40,
                                child: Text(
                                  dishAdded[index].dishName,
                                  style: TextStyle(fontSize: fontHeight * 3.0),
                                )),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.green[900],
                                  borderRadius: BorderRadius.circular(30.0)),
                              // margin: EdgeInsets.symmetric(vertical: scrHeight * 1.5),
                              width: scrWidth * 25,
                              height: scrHeight * 5,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        widget.onChanged(
                                          "remove",
                                          dishAdded[index].dishId,
                                          dishAdded[index],
                                        );
                                        if (dishAdded[index].dishCount == 0) {
                                          dishAdded.remove(dishAdded[index]);
                                        }
                                      });
                                      getItemCount();
                                    },
                                    child: Icon(
                                      Icons.remove,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    '${dishAdded[index].dishCount}',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        widget.onChanged(
                                          "add",
                                          dishAdded[index].dishId,
                                          dishAdded[index],
                                        );
                                        getItemCount();
                                      });
                                    },
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: scrWidth * 25,
                              child: Text(
                                'INR ${(dishAdded[index].dishPrice) * (dishAdded[index].dishCount)}',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: fontHeight * 2.25,
                                ),
                              ),
                            )
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'INR ${dishAdded[index].dishPrice}',
                              style: TextStyle(
                                fontSize: fontHeight * 2.25,
                              ),
                            ),
                            Text(
                              '${dishAdded[index].dishCal} Calories',
                              style: TextStyle(
                                fontSize: fontHeight * 2.25,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                ListTile(
                  title: Text(
                    'Total Amount',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: fontHeight * 2.5,
                    ),
                  ),
                  trailing: totalAmount(),
                ),
              ],
            ),
          ),
          Container(
            width: scrWidth * 90,
            height: scrHeight * 10,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: total != 0
                    ? MaterialStateProperty.all(Colors.green[900])
                    : MaterialStateProperty.all(Colors.grey),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                )),
              ),
              onPressed: total != 0
                  ? () {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            Future.delayed(Duration(seconds: 3), () async {
                              Navigator.of(context).pop(true);
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => Home(
                                    username: widget.userName,
                                    uid: widget.uid,
                                    image: widget.image,
                                  ),
                                ),
                              );
                            });
                            return AlertDialog(
                              title: Text("Order successfully placed"),
                            );
                          });
                    }
                  : null,
              child: Text(
                'Place Order',
                style: TextStyle(
                  fontSize: fontHeight * 3.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getDishName(String dishId) {
    debugger();
    String dishName = '';
    cartItemController.menuitems.forEach((key, value) {
      for (var item in value) {
        if (item.dishId == dishId) {
          dishName = item.dishName;
          print(item.dishName);
        }
      }
    });
    return dishName;
  }

  double roundDouble(double value, int places) {
    num mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  Widget totalAmount() {
    total = 0;
    for (var item in dishAdded) {
      total += (item.dishPrice * item.dishCount);
    }
    total = roundDouble(total, 2);
    return Text('INR $total',
        style: TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
          fontSize: fontHeight * 2.5,
        ));
  }
}
