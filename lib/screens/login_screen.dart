import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:restorantapp/controller/controller.dart';
import 'package:restorantapp/screens/home.dart';
import 'package:restorantapp/utils/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  final controller = Get.find<RestorantController>();
  final mbController = TextEditingController();
  late String _verificationCode;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.fetchAllRestorantInfo();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    mbController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var scr_height = MediaQuery.of(context).size.height / 100;
    var scr_width = MediaQuery.of(context).size.width / 100;
    var font_height = MediaQuery.of(context).size.height * 0.01;
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.restaurant),
        title: Text("Login"),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: scr_width * 65,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black,
                      offset: Offset(0.0, 0.0),
                      blurRadius: 10.0),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: scr_width * 10,
                    child: Image.asset('assets/icons/google-logo.png'),
                  ),
                  TextButton(
                    onPressed: () async {
                      Map<String, dynamic> res =
                          await AuthProvider().loginWithGoogle();
                      if (res['result']) {
                        print('Logged in');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Home(
                                      username: res['username'],
                                      uid: res['uid'],
                                      image: res['image'],
                                    )));
                      } else
                        print('Log in error');
                    },
                    child: Text(
                      "Login with GOOGLE",
                      style: TextStyle(fontSize: font_height * 2.5),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: scr_height * 2.5,
            ),
            Container(
              width: scr_width * 65,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black,
                      offset: Offset(0.0, 0.0),
                      blurRadius: 10.0),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.phone,
                    color: Colors.blue,
                    size: font_height * 3.5,
                  ),
                  TextButton(
                      onPressed: () => showMessage(),
                      child: Text(
                        "Login with Mobile",
                        style: TextStyle(fontSize: font_height * 2.5),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  showMessage() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Enter Mobile Number"),
            content: TextFormField(
              controller: mbController,
              maxLength: 10,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  verifyPhoneNumber(mbController.text);
                  showOTPInputScreen();
                },
                child: Text("Send Code"),
              ),
            ],
          );
        });
  }

  showOTPInputScreen() {
    final TextEditingController _pinPutController = TextEditingController();
    final FocusNode _pinPutFocusNode = FocusNode();
    final BoxDecoration pinPutDecoration = BoxDecoration(
      color: const Color.fromRGBO(43, 46, 66, 1),
      borderRadius: BorderRadius.circular(10.0),
      border: Border.all(
        color: const Color.fromRGBO(126, 203, 224, 1),
      ),
    );
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Enter your OTP"),
            content: Padding(
              padding: const EdgeInsets.all(20.0),
              child: PinPut(
                fieldsCount: 6,
                textStyle: const TextStyle(fontSize: 25.0, color: Colors.white),
                eachFieldWidth: 40.0,
                eachFieldHeight: 55.0,
                focusNode: _pinPutFocusNode,
                controller: _pinPutController,
                submittedFieldDecoration: pinPutDecoration,
                selectedFieldDecoration: pinPutDecoration,
                followingFieldDecoration: pinPutDecoration,
                pinAnimationType: PinAnimationType.fade,
                onSubmit: (pin) async {
                  try {
                    await FirebaseAuth.instance
                        .signInWithCredential(PhoneAuthProvider.credential(
                            verificationId: _verificationCode, smsCode: pin))
                        .then((value) async {
                      if (value.user != null) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Home(
                                      image: '',
                                      uid: '',
                                      username: mbController.text,
                                    )),
                            (route) => false);
                      }
                    });
                  } catch (e) {
                    FocusScope.of(context).unfocus();
                    _scaffoldkey.currentState!
                        .showSnackBar(SnackBar(content: Text('invalid OTP')));
                  }
                },
              ),
            ),
          );
        });
  }

  verifyPhoneNumber(String phoneNumber) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91$phoneNumber',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          Home(username: phoneNumber, uid: '', image: '')));
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e);
        },
        codeSent: (String verificationID, int? resendToken) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: Duration(seconds: 120));
  }
}