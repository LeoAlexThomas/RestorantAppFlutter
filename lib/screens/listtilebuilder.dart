// import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ListTileDish extends StatefulWidget {
  late List dishes;
  final Function(String s, Map<String, dynamic> dish, int dishCount) onChanged;
  ListTileDish({
    Key? key,
    required this.dishes,
    required this.onChanged,
  }) : super(key: key);

  @override
  _ListTileDishState createState() => _ListTileDishState();
}

class _ListTileDishState extends State<ListTileDish> {
  @override
  Widget build(BuildContext context) {
    var scrHeight = MediaQuery.of(context).size.height / 100;
    var scrWidth = MediaQuery.of(context).size.width / 100;
    var fontHeight = MediaQuery.of(context).size.height * 0.01;
    // log('Dish Given: ${widget.dishes[1]}');
    return Container(
      height: scrHeight * 85,
      child: ListView.separated(
        separatorBuilder: (context, index) => Divider(
          color: Colors.grey,
        ),
        itemCount: widget.dishes.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: scrWidth * 2,
                ),
              ],
            ),
            // title: Text(widget.dishes[index]['dish_name']),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: scrWidth * 60,
                      margin: EdgeInsets.symmetric(vertical: scrHeight * 0.5),
                      child: Text(
                        widget.dishes[index]['dish_name'],
                        style: TextStyle(
                            fontSize: fontHeight * 2.5,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: scrHeight * 0.5),
                      width: scrWidth * 65,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'INR ${widget.dishes[index]['dish_price']}',
                            style: TextStyle(
                                fontSize: fontHeight * 2,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${widget.dishes[index]['dish_calories'].toInt()} calories',
                            style: TextStyle(
                                fontSize: fontHeight * 2.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: scrHeight * 0.5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              width: scrWidth * 65,
                              child: Text(
                                widget.dishes[index]['dish_description'],
                                style: TextStyle(
                                    fontSize: fontHeight * 2.0,
                                    color: Colors.grey[700]),
                              )),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.lightGreen[700],
                                borderRadius: BorderRadius.circular(30.0)),
                            margin:
                                EdgeInsets.symmetric(vertical: scrHeight * 1.5),
                            width: scrWidth * 30,
                            height: scrHeight * 5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      widget.onChanged(
                                        "remove",
                                        widget.dishes[index],
                                        widget.dishes[index]['dish_count'],
                                      );
                                    });
                                  },
                                  child: Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '${widget.dishes[index]['dish_count']}',
                                  style: TextStyle(color: Colors.white),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      widget.onChanged(
                                        "add",
                                        widget.dishes[index],
                                        widget.dishes[index]['dish_count'],
                                      );
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
                          if (widget.dishes[index]['addonCat'].length != 0)
                            Text(
                              'Customizations Available',
                              style: TextStyle(color: Colors.red),
                            ),
                        ],
                      ),
                    )
                  ],
                ),
                Container(
                  child: CachedNetworkImage(
                    imageUrl: widget.dishes[index]['dish_image'],
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        Icon(Icons.dining_sharp),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
