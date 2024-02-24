import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:englico/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/authentication_service.dart';

class UserState {
  final bool canWatch;

  UserState({required this.canWatch});

  UserState copyWith({
    bool? canWatch,

  }) => UserState(
    canWatch: canWatch ?? this.canWatch,
  );
}

class UserController extends StateNotifier<UserState> {

  UserController(UserState state) : super(state);


  logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("uid");
    await Authentication.signOut(context: context);
  }

  deleteAccount(BuildContext context) async {
    User user = FirebaseAuth.instance.currentUser!;
    String uid = user.uid;

    try {
      await user.delete();
      await FirebaseFirestore.instance.collection("users").doc(uid).delete();
    }
    catch(e) {
      logout(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Yeniden giriş yaptıktan sonra hesabınızı silebilirsiniz."),
      ));
    }

  }


  Future<bool> canWatchRewardedAd() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey("rewardedAdDateTime")) {
      int dateTime = prefs.getInt("rewardedAdDateTime")!;

      if(dateTime <= DateTime.now().millisecondsSinceEpoch) {
        if(prefs.containsKey("rewardedAdCount")) {

          int count = prefs.getInt("rewardedAdCount")!;
          debugPrint("Ad Count: $count");
          if(count <= 2) {
            prefs.setInt("rewardedAdCount", count + 1);
            state = state.copyWith(canWatch: true);
            return true;
          }
          else if(count > 2){
            prefs.setInt("rewardedAdDateTime", DateTime.now().add(Duration(hours: 24)).millisecondsSinceEpoch);
            prefs.setInt("rewardedAdCount", 0);
            state = state.copyWith(canWatch: false);
            return false;
          }
        }
        else {
          prefs.setInt("rewardedAdCount", 0);
          state = state.copyWith(canWatch: true);
          return true;
        }
      }

      else {
        state = state.copyWith(canWatch: false);
        return false;
      }

    }

    else {
      prefs.setInt("rewardedAdDateTime", DateTime.now().millisecondsSinceEpoch);
      state = state.copyWith(canWatch: true);
      return true;
    }
    state = state.copyWith(canWatch: false);

    return false;
  }
}

final userController = StateNotifierProvider<UserController, UserState>((ref) => UserController(UserState(
    canWatch: true
)));