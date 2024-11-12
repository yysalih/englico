import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englico/models/money_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/v4.dart';

import '../models/user_model.dart';

class MoneyState {

}

class MoneyController extends StateNotifier<MoneyState> {
  MoneyController(super.state);

  TextEditingController ibanController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  sendRequest(UserModel user) async {

    String uid = const Uuid().v4();
    await FirebaseFirestore.instance.collection("requests").doc(uid).set(
      MoneyModel(
        uid: uid,
        name: nameController.text,
        amount: user.money,
        date: DateTime.now().millisecondsSinceEpoch,
        status: "waiting",
        iban: ibanController.text,
        userId: user.uid
      ).toJson()
    );

    await FirebaseFirestore.instance.collection("users").doc(user.uid).update({
      "money" : 0.001
    });

    ibanController.clear();
    nameController.clear();
  }


}

final moneyController = StateNotifierProvider<MoneyController, MoneyState>((ref) => MoneyController(
  MoneyState()
));