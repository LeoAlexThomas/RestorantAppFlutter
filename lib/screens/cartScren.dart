import 'dart:math';

import 'package:flutter/material.dart';
import 'package:restorantapp/screens/home.dart';

class CartScreen extends StatefulWidget {
  final items;
  final userName;
  final uid;
  final image;
  final Map<String, int> itemCount;
  final Function(String oper, Map<String, dynamic> selectedDish,
      Map<String, int> updatedCount) onChanged;
  const CartScreen(
      {Key? key,
      required this.items,
      required this.itemCount,
      required this.onChanged,
      this.userName,
      this.uid,
      this.image})
      : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var scrHeight;
  var scrWidth;
  var fontHeight;
  double sums = 0;
  int items = 0;

  Map<String, dynamic> dishPrice = {};

  @override
  void initState() {
    super.initState();

    for (var i = 0; i < widget.items.length; i++) {
      sums = sums +
          (widget.items[i]['dish_price'] *
              widget.itemCount[widget.items[i]['dish_name']]);
      sums = roundDouble(sums, 2);
    }
    widget.itemCount.forEach((key, value) {
      items += value;
    });
  }

  double roundDouble(double value, int places) {
    num mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  addItem(double price) {
    sums += price;
    sums = roundDouble(sums, 2);

    items++;
  }

  removeItem(double price) {
    sums -= price;
    sums = roundDouble(sums, 2);

    if (widget.items.length == 0)
      items = 0;
    else
      items--;
  }

  @override
  Widget build(BuildContext context) {
    scrHeight = MediaQuery.of(context).size.height / 100;
    scrWidth = MediaQuery.of(context).size.width / 100;
    fontHeight = MediaQuery.of(context).size.height * 0.01;
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        title: Text(
          'Order Summary',
          style: TextStyle(color: Colors.grey),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context, widget.itemCount),
          icon: Icon(
            Icons.arrow_back,
            color: Colors.grey,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: scrHeight * 2),
            width: scrWidth * 90,
            height: scrHeight * 7.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              color: Colors.green[700],
            ),
            child: Center(
                child: Text(
              '${widget.items.length} Dishes - $items Items',
              style: TextStyle(
                fontSize: fontHeight * 3.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            )),
          ),
          Container(
            width: double.infinity,
            height: scrHeight * 55,
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: scrWidth * 37,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: scrHeight * 2.5),
                                child: Text(
                                  widget.items[index]['dish_name'],
                                  style: TextStyle(fontSize: fontHeight * 3),
                                ),
                              ),
                              Text(
                                'INR ${widget.items[index]['dish_price']}',
                                style: TextStyle(fontSize: fontHeight * 2.5),
                              ),
                              SizedBox(
                                height: scrHeight * 1,
                              ),
                              Text(
                                '${widget.items[index]['dish_calories'].toInt()} calories',
                                style: TextStyle(fontSize: fontHeight * 2.5),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.lightGreen[700],
                              borderRadius: BorderRadius.circular(30.0)),
                          margin:
                              EdgeInsets.symmetric(vertical: scrHeight * 1.5),
                          width: scrWidth * 25,
                          height: scrHeight * 5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    removeItem(
                                        widget.items[index]['dish_price']);
                                    if (widget.itemCount[widget.items[index]
                                            ['dish_name']]! >
                                        0) {
                                      widget.itemCount[widget.items[index]
                                          ['dish_name']] = widget.itemCount[
                                              widget.items[index]
                                                  ['dish_name']]! -
                                          1;
                                    }
                                    widget.onChanged("remove",
                                        widget.items[index], widget.itemCount);
                                  });
                                },
                                child: Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                  size: fontHeight * 1.75,
                                ),
                              ),
                              Text(
                                // '0',
                                '${widget.itemCount[widget.items[index]["dish_name"]]}',
                                style: TextStyle(color: Colors.white),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    widget.itemCount[widget.items[index]
                                        ["dish_name"]] = widget.itemCount[
                                            widget.items[index]["dish_name"]]! +
                                        1;
                                    // print(
                                    //     'Selected Dish: ${widget.items[index].runtimeType}');
                                    // print('DishCount: ${widget.itemCount}');
                                    widget.onChanged("add", widget.items[index],
                                        widget.itemCount);
                                    // print('added');
                                    addItem(widget.items[index]['dish_price']);
                                  });
                                },
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: fontHeight * 1.75,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    trailing: Container(
                        margin: EdgeInsets.symmetric(vertical: scrHeight * 1),
                        child: Text(
                          updatePrice(index),
                          style: TextStyle(fontSize: fontHeight * 2.25),
                        )),
                  );
                },
                separatorBuilder: (context, index) => Divider(),
                itemCount: widget.items.length),
          ),
          Container(
            margin: EdgeInsets.symmetric(
                vertical: scrHeight * 2, horizontal: scrWidth * 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Amount:',
                  style: TextStyle(
                      fontSize: fontHeight * 3, fontWeight: FontWeight.bold),
                ),
                Text(
                  'INR ${sums.toString()}',
                  style: TextStyle(
                    fontSize: fontHeight * 3,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: scrWidth * 90,
            height: scrHeight * 10,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                )),
              ),
              onPressed: widget.items.length != 0
                  ? () {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            Future.delayed(Duration(seconds: 5), () async {
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

  updatePrice(int index) {
    var price = widget.items[index]['dish_price'] *
        widget.itemCount[widget.items[index]['dish_name']];
    dishPrice[widget.items[index]['dish_name']] = price;
    // setState(() {});
    return "INR : $price";
  }

  updateCartItems(
    String oper,
    Map<String, dynamic> selectedDish,
    Map<String, int> updatedCount,
  ) {
    // print('Selected dishes: $updatedCount');
    setState(() {
      switch (oper) {
        case "add":
          if (widget.items.contains(selectedDish)) {
            widget.items.add(selectedDish);
          }

          break;
        case "remove":
          if (widget.itemCount[selectedDish['dish_name']] == 0) {
            if (widget.items.contains(selectedDish)) {
              int index = widget.items.indexOf(selectedDish);
              widget.items.removeAt(index);
              // print('itemRemoved $res');
            }
          }
          break;
      }
    });
    // print(selectedDish['dish_name']);
    // print(cartItems);
  }
}
