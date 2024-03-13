import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:englico/models/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/authentication_service.dart';
import 'package:path/path.dart';

import '../utils/contants.dart';

class UserState {
  final bool canWatch;
  final int activeIndex;

  final String userName;
  final String name;

  final File photo;
  final bool isCompleted;
  final String image;
  final List<File> pickedFiles;

  UserState( {required this.canWatch, required this.activeIndex,
    required this.photo, required this.isCompleted, required this.image, required this.pickedFiles,
    required this.name, required this.userName
  });

  UserState copyWith({
    bool? canWatch,
    int? activeIndex,
    File? photo,
    bool? isCompleted,
    String? image,
    String? name,
    String? userName,
    List<File>? pickedFiles,

  }) => UserState(
    canWatch: canWatch ?? this.canWatch,
    name: name ?? this.name,
    userName: userName ?? this.userName,
    activeIndex: activeIndex ?? this.activeIndex,
    photo: photo ?? this.photo,
    isCompleted: isCompleted ?? this.isCompleted,
    image: image ?? this.image,
    pickedFiles: pickedFiles ?? this.pickedFiles,
  );
}

class UserController extends StateNotifier<UserState> {

  UserController(UserState state) : super(state);

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();


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
      "point" : user.point! + point,
      "annuallyPoint" : user.annuallyPoint! + point,
      "monthlyPoint" : user.monthlyPoint! + point
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
        "savedWords" : user.savedWords!..remove(wordUid)
      });
    }
    else {
      debugPrint("here else");

      await FirebaseFirestore.instance.collection("users").doc(user.uid).update({
        "savedWords" : user.savedWords!..add(wordUid)
      });
    }

  }

  Future imgFromCamera(BuildContext context) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera, imageQuality: 25);
    if (pickedFile != null) {
      state = state.copyWith(
          pickedFiles: state.pickedFiles..add(File(pickedFile.path)),
          photo: File(pickedFile.path)
      );
      uploadFile();
    } else {
      debugPrint('No image selected.');
    }
  }

  Future imgFromGallery(BuildContext context) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 25);

    if (pickedFile != null) {
      state = state.copyWith(
          pickedFiles: state.pickedFiles..add(File(pickedFile.path)),
          photo: File(pickedFile.path)
      );

      uploadFile();
    } else {
      debugPrint('No image selected.');
    }

  }

  Future uploadFile() async {

    final fileName = basename(state.photo.path);

    state = state.copyWith(isCompleted: true);

    final destination = 'files/$fileName';

    try {
      final ref = FirebaseStorage.instance.ref(destination);
      await ref.putFile(state.photo);
      var pathReference = _storage.ref('files/$fileName');

      pathReference.getDownloadURL().then((value) async {

        state = state.copyWith(isCompleted: true, image: value);

      });

    } catch (e) {
      debugPrint('error occured: $e');
    }
  }
  showPicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_camera, color: Constants.kPrimaryColor,),
                  title: const Text('Fotoğraf',),
                  onTap: () {
                    imgFromCamera(context);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.image, color: Constants.kPrimaryColor,),
                  title: const Text('Galeri',),
                  onTap: () {
                    imgFromGallery(context);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  updateUser(String uid) async {
    await FirebaseFirestore.instance.collection("users").doc(uid).update({
      "username" : state.userName,
      "name" : state.name,
      "image" : state.image
    });
  }

  setFields(UserModel user) {
    state = state.copyWith(image: user.image!, userName: user.username!, name: user.name!);
  }

  changeName(String value) {
    state = state.copyWith(name: value);
  }
  changeUsername(String value) {
    state = state.copyWith(userName: value);
  }
  changeImage(String value) {
    state = state.copyWith(image: value);
  }
}

final userController = StateNotifierProvider<UserController, UserState>((ref) => UserController(UserState(
    canWatch: true, activeIndex: 0, image: "", photo: File(""), pickedFiles: [], isCompleted: false,
  userName: "", name: ""
)));