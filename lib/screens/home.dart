import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:restorantapp/controller/controller.dart';
import 'package:restorantapp/models/itemcards.dart';
import 'package:restorantapp/screens/cartScren.dart';
import 'package:restorantapp/screens/login_screen.dart';
import 'package:restorantapp/utils/firebase_auth.dart';

class Home extends StatefulWidget {
  final String username;
  final String uid;
  final String image;
  const Home(
      {Key? key,
      required this.username,
      required this.uid,
      required this.image})
      : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final RestorantController controller = RestorantController.to;
  var information;
  _HomeState() {
    information = controller.info.first;
  }
  List<Map<String, dynamic>> cartItems = [];
  int itemCount = 0;
  List menuList = [];
  List dishes = [];
  List<Widget> tabs = [];
  List<Widget> tabChidren = [];

  Map<String, int> dishCount = {};
  int sum_selected_items = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Timer.periodic(Duration(seconds: 1), (t) => setState(() {}));
    initialStep();
    tabWidget(menuList);
    tabBarWidget(menuList);
    // print('DishesCount: $dishCount');
  }

  @override
  Widget build(BuildContext context) {
    var scr_width = MediaQuery.of(context).size.width / 100;
    var scr_height = MediaQuery.of(context).size.height / 100;
    var font_height = MediaQuery.of(context).size.height * 0.01;
    // print('Dishes: $dishes');
    return DefaultTabController(
      length: menuList.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(information.restaurant_name),
          bottom: TabBar(
            tabs: tabs,
            isScrollable: true,
          ),
          actions: [
            Container(
              child: new Stack(
                children: [
                  new IconButton(
                    onPressed: () {
                      print('Cart Page');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => CartScreen(
                              items: cartItems,
                              itemCount: dishCount,
                              onChanged: (String oper,
                                      Map<String, dynamic> selectedDish,
                                      Map<String, int> updatedCount) =>
                                  updateCartItems(
                                      oper, selectedDish, updatedCount),
                            ),
                          ));
                    },
                    icon: Icon(Icons.shopping_cart),
                  ),
                  new Positioned(
                    top: 3.0,
                    right: 4.0,
                    child: new Center(
                      child: new Text(
                        cartItems.length.toString(),
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: font_height * 2.2,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    )),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child: widget.image != ''
                          ? Image.network(widget.image)
                          : Icon(Icons.person),
                    ),
                    Text(widget.username),
                    widget.uid != '' ? Text('ID: ${widget.uid}') : Text(''),
                  ],
                ),
              ),
              // TextButton(
              //   onPressed: () async {
              //     await AuthProvider().logout();
              //     Navigator.push(context,
              //         MaterialPageRoute(builder: (context) => LoginScreen()));
              //   },
              //   child: Container(
              //     width: scr_width * 25,
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //       children: [
              //         Icon(Icons.logout),
              //         Text('LOGOUT'),
              //       ],
              //     ),
              //   ),
              // ),
              ListTile(
                onTap: () async {
                  await AuthProvider().logout();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                leading: Icon(Icons.logout),
                title: Text('LOG OUT'),
              ),
            ],
          ),
        ),
        body: TabBarView(children: tabChidren),
      ),
    );
  }

  initialStep() {
    for (var item in information.table_menu_list) {
      menuList.add(item['menu_category']);
      dishes.add(item['category_dishes']);
    }
    // print(dishes.first.first.runtimeType);
  }

  tabWidget(List items) {
    for (var item in items) {
      tabs.add(
        Tab(text: item),
      );
    }
  }

  tabBarWidget(List items) {
    for (var i = 0; i < items.length; i++) {
      for (var j = 0; j < dishes[i].length; j++) {
        dishCount[dishes[i][j]['dish_name']] = 0;
      }
      tabChidren.add(
        ListItemsWidget(
          dishes: dishes[i],
          onChanged: (String operation, Map<String, dynamic> selectedDish,
                  Map<String, int> updatedCount) =>
              updateCartItems(operation, selectedDish, updatedCount),
          dishCount: dishCount,
        ),
      );
    }
    // print(dishCount);
  }

  updateCartItems(String oper, Map<String, dynamic> selectedDish,
      Map<String, int> updatedCount) {
    // print('Selected dishes: $updatedCount');
    setState(() {
      dishCount = updatedCount;
      switch (oper) {
        case "add":
          if (!cartItems.contains(selectedDish)) {
            cartItems.add(selectedDish);
          }
          break;
        case "remove":
          if (dishCount[selectedDish['dish_name']] == 0) {
            if (cartItems.contains(selectedDish)) {
              int index = cartItems.indexOf(selectedDish);
              Map<String, dynamic> res = cartItems.removeAt(index);
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
