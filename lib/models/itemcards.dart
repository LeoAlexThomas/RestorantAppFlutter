import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ListItemsWidget extends StatefulWidget {
  final List dishes;
  final Map<String, int> dishCount;
  final Function(String oper, Map<String, dynamic> selectedDish,
      Map<String, int> updatedCount) onChanged;
  const ListItemsWidget(
      {Key? key,
      required this.dishes,
      required this.onChanged,
      required this.dishCount})
      : super(key: key);

  @override
  _ListItemsWidgetState createState() => _ListItemsWidgetState();
}

class _ListItemsWidgetState extends State<ListItemsWidget> {
  var scr_height;
  var scr_width;
  var font_height;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    scr_height = MediaQuery.of(context).size.height / 100;
    scr_width = MediaQuery.of(context).size.width / 100;
    font_height = MediaQuery.of(context).size.height * 0.01;
    // print(widget.dishes.length);
    return ListView.separated(
        separatorBuilder: (context, index) => Divider(
              color: Colors.grey,
            ),
        itemCount: widget.dishes.length,
        itemBuilder: (context, index) {
          return ListTile(
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: scr_width * 2,
                ),
              ],
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: scr_width * 60,
                      margin: EdgeInsets.symmetric(vertical: scr_height * 0.5),
                      child: Text(
                        widget.dishes[index]['dish_name'],
                        style: TextStyle(
                            fontSize: font_height * 2.5,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: scr_height * 0.5),
                      width: scr_width * 65,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'INR ${widget.dishes[index]['dish_price']}',
                            style: TextStyle(
                                fontSize: font_height * 2,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${widget.dishes[index]['dish_calories'].toInt()} calories',
                            style: TextStyle(
                                fontSize: font_height * 2.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: scr_height * 0.5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              width: scr_width * 65,
                              child: Text(
                                widget.dishes[index]['dish_description'],
                                style: TextStyle(
                                    fontSize: font_height * 2.0,
                                    color: Colors.grey[700]),
                              )),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.lightGreen[700],
                                borderRadius: BorderRadius.circular(30.0)),
                            margin: EdgeInsets.symmetric(
                                vertical: scr_height * 1.5),
                            width: scr_width * 30,
                            height: scr_height * 5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (widget.dishCount[widget.dishes[index]
                                              ['dish_name']]! >
                                          0) {
                                        widget.dishCount[widget.dishes[index]
                                            ['dish_name']] = widget.dishCount[
                                                widget.dishes[index]
                                                    ['dish_name']]! -
                                            1;
                                      }
                                      widget.onChanged(
                                          "remove",
                                          widget.dishes[index],
                                          widget.dishCount);
                                    });
                                  },
                                  child: Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '${widget.dishCount[widget.dishes[index]["dish_name"]]}',
                                  style: TextStyle(color: Colors.white),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      widget.dishCount[widget.dishes[index]
                                          ["dish_name"]] = widget.dishCount[
                                              widget.dishes[index]
                                                  ["dish_name"]]! +
                                          1;
                                      widget.onChanged(
                                          "add",
                                          widget.dishes[index],
                                          widget.dishCount);
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
        });
  }
}
