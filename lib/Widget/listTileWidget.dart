import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:restorantapp/controller/menuController.dart';
import 'package:restorantapp/models/menuItems.dart';

class ListTileBuilder extends StatefulWidget {
  final String dishCat;
  final Function(String oper, String dishCat, DishItems dish) onChanged;
  ListTileBuilder({
    Key? key,
    required this.onChanged,
    required this.dishCat,
  }) : super(key: key);

  @override
  _ListTileBuilderState createState() => _ListTileBuilderState();
}

class _ListTileBuilderState extends State<ListTileBuilder> {
  final MenuItemController menuController = MenuItemController.to;
  var scrHeight;
  var scrWidth;
  var fontHeight;

  @override
  Widget build(BuildContext context) {
    scrHeight = MediaQuery.of(context).size.height / 100;
    scrWidth = MediaQuery.of(context).size.width / 100;
    fontHeight = MediaQuery.of(context).size.height * 0.01;
    // print('Menu Cat: ${widget.dishCat}');
    // print(
    //     'Model Menu Cat: ${menuController.menuitems[widget.dishCat]!.length}');
    return ListView.separated(
      itemCount: menuController.menuitems[widget.dishCat]!.length,
      separatorBuilder: (BuildContext context, int index) {
        return Divider();
      },
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          trailing: Container(
            height: scrHeight * 10,
            width: scrWidth * 20,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image/dish_image.jpg'),
                fit: BoxFit.fill,
              ),
              shape: BoxShape.rectangle,
            ),
            child: Icon(
              Icons.dining,
              color: Colors.white,
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: scrWidth * 60,
                margin: EdgeInsets.symmetric(vertical: scrHeight * 0.5),
                child: Text(
                  menuController.menuitems[widget.dishCat]![index].dishName,
                  style: TextStyle(
                      fontSize: fontHeight * 2.5, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: scrHeight * 0.5),
                width: scrWidth * 65,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'INR ${menuController.menuitems[widget.dishCat]![index].dishPrice}',
                      style: TextStyle(
                          fontSize: fontHeight * 2.25,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${menuController.menuitems[widget.dishCat]![index].dishCal} calories',
                      style: TextStyle(
                          fontSize: fontHeight * 2.25,
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
                          menuController
                              .menuitems[widget.dishCat]![index].dishDesc,
                          style: TextStyle(
                              fontSize: fontHeight * 2.25,
                              color: Colors.grey[700]),
                        )),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.lightGreen[700],
                          borderRadius: BorderRadius.circular(30.0)),
                      margin: EdgeInsets.symmetric(vertical: scrHeight * 1.5),
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
                                  menuController
                                      .menuitems[widget.dishCat]![index].dishId,
                                  menuController
                                      .menuitems[widget.dishCat]![index],
                                );
                              });
                            },
                            child: Icon(
                              Icons.remove,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '${menuController.menuitems[widget.dishCat]![index].dishCount}',
                            style: TextStyle(
                              fontSize: fontHeight * 2.0,
                              color: Colors.white,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                widget.onChanged(
                                  "add",
                                  menuController
                                      .menuitems[widget.dishCat]![index].dishId,
                                  menuController
                                      .menuitems[widget.dishCat]![index],
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
                    if (!menuController
                        .menuitems[widget.dishCat]![index].addOnCat)
                      Text(
                        'Customizations Available',
                        style: TextStyle(
                            fontSize: fontHeight * 2.25, color: Colors.red),
                      ),
                  ],
                ),
              )
            ],
          ),
          // leading: Icon(Icons.),
        );
      },
    );
  }
}
