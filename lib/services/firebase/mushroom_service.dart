import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:my_mushrooms_hunter/models/mushroom.dart';

Future<void> saveMushroom(Mushroom mushroom) async {
  String? userID = FirebaseAuth.instance.currentUser?.uid;

  if (userID == null) {
    print('User not logged in');
    return;
  }

  DocumentReference documentRef =
      FirebaseFirestore.instance.collection('mushrooms').doc();

  await documentRef.set(mushroom.toFirestoreMap(userID)).catchError((error) {
    debugPrint("Failed to add mushroom: $error");
  });
}

Future<void> updateMushroom(Mushroom mushroom) async {
  String? userID = FirebaseAuth.instance.currentUser?.uid;

  if (userID == null) {
    print('User not logged in');
    return;
  }

  DocumentReference documentRef =
      FirebaseFirestore.instance.collection('mushrooms').doc(mushroom.id);

  await documentRef.update(mushroom.toFirestoreMap(userID)).catchError((error) {
    debugPrint("Failed to update mushroom: $error");
  });
}

Future<void> deleteMushroom(String id) async {
  DocumentReference documentRef =
      FirebaseFirestore.instance.collection('mushrooms').doc(id);

  await documentRef.delete().catchError((error) {
    debugPrint("Failed to delete mushroom: $error");
  });
}

Future<List<Mushroom>> fetchUserMushrooms(String userId) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  QuerySnapshot querySnapshot = await firestore
      .collection('mushrooms')
      .where('userID', isEqualTo: userId)
      .orderBy('dateFound', descending: true)
      .get();

  return querySnapshot.docs.map((doc) => Mushroom.fromFirestore(doc)).toList();
}

Stream<List<Mushroom>> streamUserMushrooms(String userId) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  return firestore
      .collection('mushrooms')
      .where('userID', isEqualTo: userId)
      .orderBy('dateFound', descending: true)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Mushroom.fromFirestore(doc)).toList());
}
