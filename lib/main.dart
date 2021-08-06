import 'package:flutter/material.dart';
import 'package:restorantapp/controller/controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

import 'screens/home.dart';
import 'screens/login_screen.dart';
import 'screens/splashScreen.dart';

void main() async {
  Get.put(RestorantController());
  // await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
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
            return Scaffold(
              body: Center(
                child: Text("Something Went wrong"),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return LoginScreen();
          }

          return SplashScreen();
        });
  }
}
