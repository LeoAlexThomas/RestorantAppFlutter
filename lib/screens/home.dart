import 'package:flutter/material.dart';
import 'package:restorantapp/Widget/listTileWidget.dart';
import 'package:restorantapp/controller/menuController.dart';
import 'package:restorantapp/controller/controller.dart';
import 'package:restorantapp/models/menuItems.dart';
import 'package:restorantapp/screens/cartScreen.dart';
import 'package:restorantapp/screens/login_screen.dart';
import 'package:restorantapp/utils/firebase_auth.dart';

class Home extends StatefulWidget {
  // getting username, uid, image url from auth process
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
  // Getting instance of classes which is extented get package
  final RestorantController resController = RestorantController.to;
  final MenuItemController menuController = MenuItemController.to;

  var information;
  _HomeState() {
    information = resController.info.first;
  }

  List menuList = [];
  List dishes = [];
// Tab Menu View
  List<Widget> tabs = [];
// Tab Detailed View
  List<Widget> tabChidren = [];
// Loading Widget for Tab Bar
  List<Widget> tabLoadingWidget = [];
// For Cart number at top of screen
  List<DishItems> cartItemAdded = [];

  @override
  void initState() {
    super.initState();
    // store data based on their category
    initialStep();
    // creating menu tab widget
    tabWidget(menuList);
    // creating tab Loading widget
    tabLoading(menuList);
    // Calling cartItem fun for initial assign
    getCartItems();
  }

// Getting how much dish is added to cart
  getCartItems() {
    menuController.menuitems.forEach((key, value) {
      for (var item in value) {
        if (item.addToCart) {
          if (!cartItemAdded.contains(item)) cartItemAdded.add(item);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var scrWidth = MediaQuery.of(context).size.width / 100;
    var scrHeight = MediaQuery.of(context).size.height / 100;
    var fontHeight = MediaQuery.of(context).size.height * 0.01;
    return DefaultTabController(
      length: menuList.length,
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          iconTheme: IconThemeData(color: Colors.grey),
          backgroundColor: Colors.white,
          title: Text(
            information.restaurantName,
            style: TextStyle(fontSize: fontHeight * 2.5, color: Colors.grey),
          ),
          bottom: TabBar(
            labelColor: Colors.red,
            indicatorColor: Colors.red,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(
                fontSize: fontHeight * 2.0, fontWeight: FontWeight.bold),
            tabs: tabs,
            isScrollable: true,
          ),
          actions: [
            Container(
              child: new Stack(
                children: [
                  new IconButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (BuildContext context) {
                          return CartScreenAlt(
                            onChanged: (String oper, String dishId, dish) =>
                                updateCartItems(oper, dishId, dish),
                            userName: widget.username,
                            uid: widget.uid,
                            image: widget.image,
                          );
                        },
                      ));
                    },
                    icon: Icon(
                      Icons.shopping_cart,
                      color: Colors.grey,
                    ),
                  ),
                  new Positioned(
                    top: 3.0,
                    right: 4.0,
                    child: new Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: scrHeight * 0.15,
                          horizontal: scrWidth * 0.15,
                        ),
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(50.0)),
                        child: new Text(
                          '${cartItemAdded.length}',
                          style: new TextStyle(
                            color: Colors.white,
                            fontSize: fontHeight * 2,
                            fontWeight: FontWeight.w500,
                          ),
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
              Container(
                height: scrHeight * 30,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        // begin: ,
                        colors: [
                          Colors.green,
                          Colors.lightGreen,
                        ],
                      ),
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
                      Text(
                        widget.username,
                        style: TextStyle(fontSize: fontHeight * 2.5),
                      ),
                      widget.uid != ''
                          ? Text(
                              'ID: ${widget.uid}',
                              style: TextStyle(fontSize: fontHeight * 1.5),
                            )
                          : Text(''),
                    ],
                  ),
                ),
              ),
              ListTile(
                onTap: () async {
                  await AuthProvider().logout();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                leading: Icon(Icons.logout),
                title: Text(
                  'Log Out',
                  style: TextStyle(
                      fontSize: fontHeight * 2, color: Colors.grey[700]),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(children: tabBarView),
      ),
    );
  }

// Creating detailed tabs
  List<Widget> get tabBarView {
    List<Widget> tabbars = [];
    for (var i = 0; i < menuList.length; i++) {
      // log('Dish :${dishes[i].runtimeType}');
      tabbars.add(ListTileBuilder(
          onChanged: (String oper, String dishId, DishItems dish) =>
              updateCartItems(oper, dishId, dish),
          dishCat: menuList[i]));
    }

    return tabbars;
  }

// This function will execute first to distribute the data based on their category
  initialStep() {
    for (var item in information.tableMenuList) {
      menuList.add(item['menu_category']);
      dishes.add(item['category_dishes']);
    }
    for (var i = 0; i < dishes.length; i++) {
      List<DishItems> items = [];
      for (var j = 0; j < dishes[i].length; j++) {
        items.add(DishItems(
          dishes[i][j]['dish_id'],
          dishes[i][j]['dish_name'],
          dishes[i][j]['dish_price'],
          dishes[i][j]['dish_calories'].toInt(),
          0, //dishCount
          dishes[i][j]['dish_description'],
          dishes[i][j]['addonCat'].length == 0 ? true : false,
          dishes[i][j]['dish_image'],
          false, //addToCart initial value
        ));
      }
      // Calling add fun from controller
      menuController.add('${menuList[i]}', items);
    }
  }

// Creating Menu Tabs
  tabWidget(List items) {
    for (var item in items) {
      tabs.add(
        Tab(text: item),
      );
    }
  }

// Creating Tab Loading widget
  void tabLoading(List items) {
    for (var i = 0; i < items.length; i++) {
      tabLoadingWidget.add(
        Center(
            child: Container(
          child: CircularProgressIndicator(),
        )),
      );
    }
  }

// Update cart items based on user input [Using Dish Id to update cart item]
  updateCartItems(String action, String dishId, DishItems dish) {
    setState(() {
      // print(dishCat);
      if (action == 'add') {
        menuController.menuitems.forEach((key, value) {
          for (var item in value) {
            if (item.dishId == dishId) {
              item.dishCount++;
              item.addToCart = true;
            }
          }
        });
        getCartItems();
      } else if (action == 'remove') {
        menuController.menuitems.forEach((key, value) {
          for (var item in value) {
            if (item.dishId == dishId) {
              if (item.dishCount > 0) {
                item.dishCount--;
                if (item.dishCount == 0) {
                  item.addToCart = false;
                }
              }
            }
          }
        });
        if (!cartItemAdded[cartItemAdded.indexOf(dish)].addToCart)
          cartItemAdded.remove(dish);
      }
    });
  }
}
