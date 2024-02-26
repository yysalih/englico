import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englico/models/word_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WordRepository {
  final FirebaseFirestore _firebaseFirestore;
  final String _uid;

  WordRepository({FirebaseFirestore? firebaseFirestore,  String? uid})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance, _uid = uid ?? "";

  Stream<List<WordModel>> getWords() {
    return _firebaseFirestore.collection("words").snapshots().map((snapshot) {
      return snapshot.docs.map((e) => const WordModel().fromJson(e.data())).toList();
    });
  }

  Stream<WordModel> getWord() {
    return _firebaseFirestore.collection("words").doc(_uid).snapshots().map((event) =>
        const WordModel().fromJson(event.data()!));
  }
}

final wordsStreamProvider = StreamProvider.autoDispose<List<WordModel>>((ref) {
  final wordRepository = ref.watch(wordsRepositoryProvider);
  return wordRepository.getWords();
});
final wordsRepositoryProvider = Provider<WordRepository>((ref) {
  return WordRepository(firebaseFirestore: FirebaseFirestore.instance); // declared elsewhere
});

final wordStreamProvider = StreamProvider.autoDispose.family<WordModel, String?>((ref, uid) {
  final wordRepository = ref.watch(wordRepositoryProvider(uid));

  return wordRepository.getWord();
});

final wordRepositoryProvider = Provider.family<WordRepository, String?>((ref, uid) {
  return WordRepository(firebaseFirestore: FirebaseFirestore.instance, uid: uid); // declared elsewhere
});