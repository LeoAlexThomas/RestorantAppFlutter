import 'dart:math';

import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  final items;
  final Map<String, int> itemCount;
  final Function(String oper, Map<String, dynamic> selectedDish,
      Map<String, int> updatedCount) onChanged;
  const CartScreen(
      {Key? key,
      required this.items,
      required this.itemCount,
      required this.onChanged})
      : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var scr_height;
  var scr_width;
  var font_height;
  double sums = 0;

  Map<String, dynamic> dishPrice = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addSums();
  }

  double roundDouble(double value, int places) {
    num mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  addSums() {
    for (var i = 0; i < widget.items.length; i++) {
      print('From items price: ${widget.items[i]['dish_price']}');
      print(
          'From ItemsCount: ${(widget.itemCount[widget.items[i]['dish_name']])}');
      sums = sums +
          (widget.items[i]['dish_price'] *
              widget.itemCount[widget.items[i]['dish_name']]);
      sums = roundDouble(sums, 2);
      print('total Price: $sums');
    }
  }

  removeSums() {
    for (var i = 0; i < widget.items.length; i++) {
      print('From items price: ${widget.items[i]['dish_price']}');
      print(
          'From ItemsCount: ${(widget.itemCount[widget.items[i]['dish_name']])}');
      sums = sums -
          (widget.items[i]['dish_price'] *
              widget.itemCount[widget.items[i]['dish_name']]);
      sums = roundDouble(sums, 2);
      print('total Price: $sums');
    }
  }

  @override
  Widget build(BuildContext context) {
    scr_height = MediaQuery.of(context).size.height / 100;
    scr_width = MediaQuery.of(context).size.width / 100;
    font_height = MediaQuery.of(context).size.height * 0.01;
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Summary'),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: scr_height * 2),
            width: scr_width * 90,
            height: scr_height * 7.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              color: Colors.green[700],
            ),
            child: Center(
                child: Text(
              '${widget.items.length} Dishes',
              style: TextStyle(
                fontSize: font_height * 3.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            )),
          ),
          Container(
            width: double.infinity,
            height: scr_height * 60,
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: scr_width * 37,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: scr_height * 2.5),
                                child: Text(
                                  widget.items[index]['dish_name'],
                                  style: TextStyle(fontSize: font_height * 3),
                                ),
                              ),
                              Text(
                                'INR ${widget.items[index]['dish_price']}',
                                style: TextStyle(fontSize: font_height * 2.5),
                              ),
                              SizedBox(
                                height: scr_height * 1,
                              ),
                              Text(
                                '${widget.items[index]['dish_calories'].toInt()} calories',
                                style: TextStyle(fontSize: font_height * 2.5),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.lightGreen[700],
                              borderRadius: BorderRadius.circular(30.0)),
                          margin:
                              EdgeInsets.symmetric(vertical: scr_height * 1.5),
                          width: scr_width * 25,
                          height: scr_height * 5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
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
                                    removeSums();
                                  });
                                },
                                child: Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                  size: font_height * 1.75,
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
                                    addSums();
                                  });
                                },
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: font_height * 1.75,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    trailing: Container(
                        margin: EdgeInsets.symmetric(vertical: scr_height * 1),
                        child: Text(
                          updatePrice(index),
                          style: TextStyle(fontSize: font_height * 2.25),
                        )),
                  );
                },
                separatorBuilder: (context, index) => Divider(),
                itemCount: widget.items.length),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: scr_width * 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Price:',
                  style: TextStyle(fontSize: font_height * 3),
                ),
                Text(
                  'INR ${sums.toString()}',
                  style: TextStyle(fontSize: font_height * 3),
                ),
              ],
            ),
          ),
          Container(
            width: scr_width * 90,
            height: scr_height * 10,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              color: Colors.grey,
            ),
            child: ElevatedButton(
              onPressed: widget.items.length == 0 ? null : () {},
              child: Text(
                'Place Order',
                style: TextStyle(
                  fontSize: font_height * 3.0,
                  fontWeight: FontWeight.bold,
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
}
