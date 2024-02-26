import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englico/models/test_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TestRepository {
  final FirebaseFirestore _firebaseFirestore;
  final String _uid;

  TestRepository({FirebaseFirestore? firebaseFirestore,  String? uid})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance, _uid = uid ?? "";

  Stream<List<TestModel>> getTests() {
    String firstUid = _uid.split("englico").first;
    return _firebaseFirestore.collection("contents").doc(firstUid)
        .collection("tests").orderBy("title").snapshots().map((snapshot) {

      return snapshot.docs.map((e) => const TestModel().fromJson(e.data())).toList();
    });
  }

  Stream<TestModel> getTest() {
    String contentUid = _uid.split("englico").first;
    String testUid = _uid.split("englico").last;

    return _firebaseFirestore.collection("contents").doc(contentUid).collection("tests").doc(testUid)
        .snapshots().map((event) => const TestModel().fromJson(event.data()!));
  }
}

final testsStreamProvider = StreamProvider.autoDispose.family<List<TestModel>, String?>((ref, uid) {
  final testRepository = ref.watch(testRepositoryProvider(uid));
  return testRepository.getTests();
});

final testStreamProvider = StreamProvider.autoDispose.family<TestModel, String?>((ref, uid) {
  final testRepository = ref.watch(testRepositoryProvider(uid));

  return testRepository.getTest();
});

final testRepositoryProvider = Provider.family<TestRepository, String?>((ref, uid) {
  return TestRepository(firebaseFirestore: FirebaseFirestore.instance, uid: uid); // declared elsewhere
});