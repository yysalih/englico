import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englico/models/content_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContentRepository {
  final FirebaseFirestore _firebaseFirestore;
  final String _uid;

  ContentRepository({FirebaseFirestore? firebaseFirestore,  String? uid})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance, _uid = uid ?? "";

  Stream<List<ContentModel>> getContents() {
    return _firebaseFirestore.collection("contents").orderBy("title").snapshots().map((snapshot) {
      return snapshot.docs.map((e) => ContentModel().fromJson(e.data())).toList();
    });
  }

  Stream<ContentModel> getContent() {
    return _firebaseFirestore.collection("contents").doc(_uid).snapshots().map((event) => ContentModel().fromJson(event.data()!));
  }
}

final contentsStreamProvider = StreamProvider.autoDispose<List<ContentModel>>((ref) {
  final contentRepository = ref.watch(contentsRepositoryProvider);
  return contentRepository.getContents();
});
final contentsRepositoryProvider = Provider<ContentRepository>((ref) {
  return ContentRepository(firebaseFirestore: FirebaseFirestore.instance); // declared elsewhere
});

final contentStreamProvider = StreamProvider.autoDispose.family<ContentModel, String?>((ref, uid) {
  final contentRepository = ref.watch(contentRepositoryProvider(uid));

  return contentRepository.getContent();
});

final contentRepositoryProvider = Provider.family<ContentRepository, String?>((ref, uid) {
  return ContentRepository(firebaseFirestore: FirebaseFirestore.instance, uid: uid); // declared elsewhere
});