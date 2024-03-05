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
  final int activeIndex;

  UserState( {required this.canWatch, required this.activeIndex,});

  UserState copyWith({
    bool? canWatch,
    int? activeIndex,

  }) => UserState(
    canWatch: canWatch ?? this.canWatch,
    activeIndex: activeIndex ?? this.activeIndex,
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

  addWordInUserWords(String wordUid, UserModel user) async {
    await FirebaseFirestore.instance.collection("users").doc(user.uid).update({
      "words" : user.words!..add(wordUid),
    });
  }

  changeActiveIndex(int index) {
    state = state.copyWith(activeIndex: index);
  }

  addPointToUser(UserModel user, int point) async {
    await FirebaseFirestore.instance.collection("users").doc(user.uid).update({
      "point" : user.point! + point
    });
  }

  addInUserTests(UserModel user, String testUid) async {
    await FirebaseFirestore.instance.collection("users").doc(user.uid).update({
      "tests" : user.tests!..add(testUid)
    });
  }

  addInUserContents(UserModel user, String contentUid) async {
    await FirebaseFirestore.instance.collection("users").doc(user.uid).update({
      "contents" : user.contents!..add(contentUid)
    });
  }

  addInUserSavedWords(UserModel user, String wordUid) async {
    debugPrint("here");
    if(user.savedWords!.contains(wordUid)) {
      debugPrint("here if");

      await FirebaseFirestore.instance.collection("users").doc(user.uid).update({
        "saved_words" : user.savedWords!..remove(wordUid)
      });
    }
    else {
      debugPrint("here else");

      await FirebaseFirestore.instance.collection("users").doc(user.uid).update({
        "saved_words" : user.savedWords!..add(wordUid)
      });
    }

  }
}

final userController = StateNotifierProvider<UserController, UserState>((ref) => UserController(UserState(
    canWatch: true, activeIndex: 0
)));