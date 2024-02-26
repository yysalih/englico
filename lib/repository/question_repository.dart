import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englico/models/question_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuestionRepository {
  final FirebaseFirestore _firebaseFirestore;
  final String _uid;

  QuestionRepository({FirebaseFirestore? firebaseFirestore,  String? uid})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance, _uid = uid ?? "";

  Stream<List<QuestionModel>> getQuestions() {
    String firstUid = _uid.split("englico").first;
    String testUid = _uid.split("englico")[1];

    return _firebaseFirestore.collection("contents").doc(firstUid).collection("tests").doc(testUid)
        .collection("questions").orderBy("title").snapshots().map((snapshot) {
      return snapshot.docs.map((e) => const QuestionModel().fromJson(e.data())).toList();
    });
  }

  Stream<QuestionModel> getQuestion() {
    String contentUid = _uid.split("englico").first;
    String testUid = _uid.split("englico")[1];
    String questionUid = _uid.split("englico")[2];

    print(contentUid);
    print(testUid);
    print(questionUid);

    return _firebaseFirestore.collection("contents").doc(contentUid).collection("tests").doc(testUid)
        .collection("questions").doc(questionUid)
        .snapshots().map((event) => const QuestionModel().fromJson(event.data()!));
  }
}

final questionsStreamProvider = StreamProvider.autoDispose.family<List<QuestionModel>, String?>((ref, uid) {
  final questionRepository = ref.watch(questionRepositoryProvider(uid));
  return questionRepository.getQuestions();
});

final questionStreamProvider = StreamProvider.autoDispose.family<QuestionModel, String?>((ref, uid) {
  final questionRepository = ref.watch(questionRepositoryProvider(uid));

  return questionRepository.getQuestion();
});

final questionRepositoryProvider = Provider.family<QuestionRepository, String?>((ref, uid) {
  return QuestionRepository(firebaseFirestore: FirebaseFirestore.instance, uid: uid); // declared elsewhere
});