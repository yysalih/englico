import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englico/models/saying_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SayingRepository {
  final FirebaseFirestore _firebaseFirestore;
  final String _uid;

  SayingRepository({FirebaseFirestore? firebaseFirestore,  String? uid})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance, _uid = uid ?? "";

  Stream<List<SayingModel>> getSayings() {
    return _firebaseFirestore.collection("sayings").snapshots().map((snapshot) {
      return snapshot.docs.map((e) => const SayingModel().fromJson(e.data())).toList();
    });
  }

  Stream<SayingModel> getSaying() {
    return _firebaseFirestore.collection("sayings").doc(_uid).snapshots().map((event) => const SayingModel().fromJson(event.data()!));
  }
}

final sayingsStreamProvider = StreamProvider.autoDispose<List<SayingModel>>((ref) {
  final sayingRepository = ref.watch(sayingsRepositoryProvider);
  return sayingRepository.getSayings();
});
final sayingsRepositoryProvider = Provider<SayingRepository>((ref) {
  return SayingRepository(firebaseFirestore: FirebaseFirestore.instance); // declared elsewhere
});

final sayingStreamProvider = StreamProvider.autoDispose.family<SayingModel, String?>((ref, uid) {
  final sayingRepository = ref.watch(sayingRepositoryProvider(uid));

  return sayingRepository.getSaying();
});

final sayingRepositoryProvider = Provider.family<SayingRepository, String?>((ref, uid) {
  return SayingRepository(firebaseFirestore: FirebaseFirestore.instance, uid: uid); // declared elsewhere
});