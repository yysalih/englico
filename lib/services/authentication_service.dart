// ignore_for_file: use_build_context_synchronously

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:englico/views/main_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/auth_controller.dart';
import '../controllers/main_controller.dart';


class Authentication {
  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;


    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential = await auth.signInWithCredential(credential);

        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        print(e);
        if (e.code == 'account-exists-with-different-credential') {
          ScaffoldMessenger.of(context).showSnackBar(
            Authentication.customSnackBar(
              content:
              'The account already exists with a different credential',
            ),
          );
        }
        else if (e.code == 'invalid-credential') {
          print(e);
          ScaffoldMessenger.of(context).showSnackBar(
            Authentication.customSnackBar(
              content:
              'Error occurred while accessing credentials. Try again.',
            ),
          );
        }
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          Authentication.customSnackBar(
            content: 'Error occurred using Google Sign In. Try again.',
          ),
        );
      }
    }

    return user;
  }

  static Future<UserCredential> signInWithApple() async {
    final appleProvider = AppleAuthProvider();
    return await FirebaseAuth.instance.signInWithProvider(appleProvider);
  }

  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  static Future<User?> handleAppleSignIn({required BuildContext context}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var auth = await signInWithApple();
    // if(auth.user != null) {
    //   try {
    //     await FirebaseFirestore.instance.collection("users").doc(auth.user!.uid).get().then((value) {
    //       print('Name of The User: ${value["name"]}');
    //       prefs.setString("uid", value["uid"]);
    //     });
    //     Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => FirstPage(),), (route) => false,);
    //     //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainPage(),), (route) => false);
    //   } // Eğer kullanıcı yeni kayıt oluyorsa "name" alanını Firebase'de kontrol ediyor. Eğer böyle bir field bulamazsa bilgileri doldurma ekranına yönlendiriyor
    //
    //   catch(E) {
    //     print("No such user as ${auth.user!.uid}");
    //
    //     prefs.setString("uid", auth.user!.uid);
    //     Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => FillOutPage(email: "", isApple: true, phone: ""),), (route) => false);
    //   }
    // }

    return auth.user;
  }

  static Future<void> signOut({required BuildContext context}) async {


    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();




    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }
  }

  static Future<void> initializeFirebase({required BuildContext context, required AuthController authWatch}) async {



    //FirebaseApp firebaseApp = await Firebase.initializeApp();
    SharedPreferences prefs = await SharedPreferences.getInstance();



    try {
      if(prefs.getString("uid") != null) {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MainView(),), (route) => false);
      }
      else
        print("No user found");


      // User? user = FirebaseAuth.instance.currentUser;
      //
      // if(user != null) {
      //   bool isUserExists = await authWatch.checkIfUserExists(user);
      //
      //   if(isUserExists) {
      //     Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MainView(),), (route) => false);
      //   }
      //   else {
      //     // await authWatch.createNewUser(user.uid, user);
      //     // Navigator.pushAndRemoveUntil(context, mainWatch.routeToSignInScreen(MainView()), (route) => false);
      //   }
      // }
      // else
      //   print("No user found");
    }
    catch (E, stackTrace) {
      print(stackTrace);
      print("Hata: $E");
    }

  }

  static Future<User?> signUp({required String email, required String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return null;
    }
  }

  //SIGN IN METHOD
  static Future<User?> signIn({required String email, required String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return null;
    }
  }

  static Future<SharedPreferences> initializeEmail({required BuildContext context}) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey("email") == true) { //Giriş yapmışsa zaten uygulamaya direkt giriş yapabiliyor
      await FirebaseFirestore.instance.collection("users").where("email", isEqualTo: prefs.getString("email")).get().then((value) {
        for(var a in value.docs) {
          prefs.setString("uid", a["uid"]);
          if(a["username"] != "") {
            //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => FirstPage(),), (route) => false);
          }
          else {
            //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => FillOutPage(email: prefs.getString("email")!, phone: ""),), (route) => false);

          }
        }


      });

    }

    return prefs;
  }

  static Future<bool> resetPassword({required String email}) async {
    bool status = false;
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: email)
        .then((value) => status=true)
        .catchError((e) => status=false);
    return status;
  }

}
