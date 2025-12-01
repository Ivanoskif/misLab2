import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritesService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> addFavorite(String recipeId, String name, String thumbnail) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _firestore.collection('favorites').doc(uid).collection('items').doc(recipeId).set({
      'name': name,
      'thumbnail': thumbnail,
      'addedAt': DateTime.now(),
    });
  }

  Future<void> removeFavorite(String recipeId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _firestore.collection('favorites').doc(uid).collection('items').doc(recipeId).delete();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getFavoritesStream() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return const Stream.empty();
    return _firestore.collection('favorites').doc(uid).collection('items').snapshots();
  }


  Stream<Map<String, dynamic>> getFavorites() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return const Stream.empty();

    return _firestore.collection('favorites').doc(uid).collection('items').snapshots().map(
          (snapshot) => { for (var doc in snapshot.docs) doc.id : true },
    );
  }
}