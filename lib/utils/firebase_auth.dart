import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>> loginWithGoogle() async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount? account = await googleSignIn.signIn();
      if (account == null) {
        print('Account not valid!!!!!!!');
        return {
          'result': false,
        };
      }
      UserCredential userCredential = await _auth.signInWithCredential(
        GoogleAuthProvider.credential(
          accessToken: (await account.authentication).accessToken,
          idToken: (await account.authentication).idToken,
        ),
      );
      if (userCredential.user == null) {
        return {
          'result': false,
        };
      }
      Map<String, dynamic> data = {
        'result': true,
        'username': userCredential.user!.displayName,
        'uid': userCredential.user!.uid,
        'image': userCredential.user!.photoURL,
      };

      return data;
    } on PlatformException catch (e) {
      print(e);
      return {
        'result': false,
      };
    } catch (e) {
      print(e);
      return {
        'result': false,
      };
    }
  }

  logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('error in logout');
    }
  }
}
