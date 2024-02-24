import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';

class UserRepository {
  final String _uid;

  UserRepository({String? uid})
      : _uid = uid ?? "";

  FirebaseFirestore _databaseReference = FirebaseFirestore.instance;


  Stream<UserModel> getUser() {
    return _databaseReference.collection("users").doc(_uid).snapshots().map((event) {
      return UserModel().fromJson(event.data()!);
    });
  }


}

final userStreamProvider = StreamProvider.autoDispose.family<UserModel, String?>((ref, uid) {
  // get repository from the provider below
  final userRepository = ref.watch(userRepositoryProvider(uid));

  // call method that returns a Stream<User>
  return userRepository.getUser();
});

final userRepositoryProvider = Provider.family<UserRepository, String?>((ref, uid) {
  return UserRepository(uid: uid);
});
