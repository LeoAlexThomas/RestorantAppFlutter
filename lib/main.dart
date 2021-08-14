import 'package:flutter/material.dart';
import 'package:restorantapp/controller/controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:restorantapp/controller/menuController.dart';

import 'screens/login_screen.dart';
import 'screens/splashScreen.dart';

void main() async {
  Get.put(RestorantController()); // This file will be use for get package
  Get.put(MenuItemController()); // This file will be use for get package
  // await Firebase.initializeApp();
  WidgetsFlutterBinding
      .ensureInitialized(); // Flutter Firebase Auth initial line
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false, // Dismiss debug banner
    home: AppState(),
  ));
}

class AppState extends StatefulWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  _AppStateState createState() => _AppStateState();
}

class _AppStateState extends State<AppState> {
  final Future<FirebaseApp> _futureApp = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _futureApp,
        builder: (context, AsyncSnapshot<FirebaseApp> snapshot) {
          if (snapshot.hasError) {
            // Return this widget if error occur
            return Scaffold(
              body: Center(
                child: Text("Something Went wrong"),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            // Return this widget if connection successfull
            return LoginScreen();
          }
          // Return this widget if connection status is waiting
          return SplashScreen();
        });
  }
}
