import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:englico/controllers/main_controller.dart';
import 'package:englico/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/authentication_service.dart';
import '../views/main_view.dart';


class AuthState {
  final bool isRegister;
  final bool isUserExists;
  final bool isApple;
  final bool hasInviteCode;
  final bool isObscure;
  final bool isResetPassword;

  AuthState({
    required this.isRegister,
    required this.isUserExists,
    required this.isApple,
    required this.hasInviteCode,
    required this.isObscure,
    required this.isResetPassword,
  });

  AuthState copyWith({
    bool? isRegister,
    bool? isUserExists,
    bool? isApple,
    bool? hasInviteCode,
    bool? isObscure,
    bool? isResetPassword,
  }) {
    return AuthState(
      isRegister: isRegister ?? this.isRegister,
      isUserExists: isUserExists ?? this.isUserExists,
      isApple: isApple ?? this.isApple,
      hasInviteCode: hasInviteCode ?? this.hasInviteCode,
      isObscure: isObscure ?? this.isObscure,
      isResetPassword: isResetPassword ?? this.isResetPassword,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  AuthController(AuthState state) : super(state);

  final User? _user = FirebaseAuth.instance.currentUser;
  User? get user => _user;

  final TextEditingController _emailController = TextEditingController();
  TextEditingController get emailController => _emailController;

  final TextEditingController _passwordController = TextEditingController();
  TextEditingController get passwordController => _passwordController;

  final TextEditingController _passwordRepeatController = TextEditingController();
  TextEditingController get passwordRepeatController => _passwordRepeatController;

  final TextEditingController _resetPasswordController = TextEditingController();
  TextEditingController get resetPasswordController => _resetPasswordController;

  final TextEditingController _inviteCodeController = TextEditingController();
  TextEditingController get inviteCodeController => _inviteCodeController;


  switchRegister() {
    state = state.copyWith(isRegister: !state.isRegister);
  }

  changeCheckBox() {
    state = state.copyWith(hasInviteCode: !state.hasInviteCode);
  }

  Future<bool> checkIfUserExists(User? _user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if(_user == null) return false;
    else {
      try {
        FirebaseFirestore fireStore = FirebaseFirestore.instance;
        final snapshot = await fireStore.collection('users').doc(_user.uid).get();
        if(snapshot.exists) {
          prefs.setString("uid", _user.uid);
          state = state.copyWith(isUserExists: true);
          return true;
        }
        else {
          state = state.copyWith(isUserExists: false);
          return false;
        }
      }
      catch(E) {
        print(E);
        state = state.copyWith(isUserExists: false);
        return false;
      }
    }
  }

  createNewUser(String uid, User _user) async {

    UserModel userModel = UserModel(
      money: 0.01,
      hasDiscount: _inviteCodeController.text.isNotEmpty,
      weeklyPoint: 0,
      annuallyPoint: 0, monthlyPoint: 0,
      tests: [], words: [], contents: [],
      image: _user.photoURL == null || _user.photoURL == ""
          ? "https://firebasestorage.googleapis.com/v0/b/pararixapp.appspot.com/o/user.png"
          "?alt=media&token=ba1f94cd-2a31-4a57-8e19-33b9af3957f5"
          : _user.photoURL,
      token: "",
      uid: uid,
      subscriptionDate: DateTime.now().millisecondsSinceEpoch,
      email: _user.email.toString(),
      username: _user.email!.split("@").first.toString(),
      name: _user.displayName.toString().isEmpty ? _user.email.toString().split("@").first : _user.displayName.toString(),
      point: 0,
      savedWords: []
    );

    await FirebaseFirestore.instance.collection("users").doc(userModel.uid)
        .set(userModel.toJson())
        .whenComplete(() => debugPrint("user created"))
        .onError((error, stackTrace) => debugPrint("Error in create method: $error"));

    if(_inviteCodeController.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection("app").doc("settings").get().then((settings) async {
        await FirebaseFirestore.instance.collection("users").doc(_inviteCodeController.text)
            .get().then((user) async {
          await FirebaseFirestore.instance.collection("users").doc(_inviteCodeController.text).update({
            "money" : user["money"] + settings["money"]
          });
        });

      });
    }
  }


  handleEmailSignIn(BuildContext context, MainController mainWatch) async {
    if(state.isRegister) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      User? user = await Authentication.signUp(
          email: _emailController.text,
          password: _passwordController.text
      );

      if(user != null) {
        prefs.setString("uid", user.uid);

        bool isUserExists = await checkIfUserExists(user);

        if(isUserExists) {
          Navigator.push(context,
              mainWatch.routeToSignInScreen(const MainView()));
        }
        else {
          await createNewUser(user.uid, user);
          Navigator.push(context,
              mainWatch.routeToSignInScreen(const MainView()));
        }

      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(
            "Kayıt sırasında bir hata oluştu."
        )));
      }
    }
    else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      User? user = await Authentication.signIn(
          email: _emailController.text,
          password: _passwordController.text
      );

      if(user != null) {
        prefs.setString("uid", user.uid);

        bool isUserExists = await checkIfUserExists(user);

        if(isUserExists) {
          Navigator.push(context,
              mainWatch.routeToSignInScreen(const MainView()));
        }
        else {
          await createNewUser(user.uid, user);
          Navigator.push(context,
              mainWatch.routeToSignInScreen(const MainView()));
        }

      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(
            "Giriş sırasında bir hata oluştu."
        )));
      }
    }
  }

  resetPassword(BuildContext context) async {
    bool status = await Authentication.resetPassword(email: _resetPasswordController.text);
    if(status) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Email adresinize şifre yenileme isteği gönderildi!"),
          )
      );
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text("Şifre yenileme isteği gönderilirken bir hata oluştu!",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
          )
      );
    }
    switchToResetPassword();
    _resetPasswordController.clear();
  }

  obscureChange() {
    state = state.copyWith(isObscure: !state.isObscure);
  }

  switchToResetPassword() {
    state = state.copyWith(isResetPassword: !state.isResetPassword);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}

final authController = StateNotifierProvider<AuthController, AuthState>(
        (ref) => AuthController(AuthState(isRegister: false, isUserExists: false,
            hasInviteCode: false, isApple: false, isObscure: true, isResetPassword: false))
);