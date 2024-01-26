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

  await documentRef.set(mushroom.toMap()).then((_) {
    documentRef.update({'userID': userID});
  }).catchError((error) {
    debugPrint("Failed to add mushroom: $error");
  });
}

Future<List<Mushroom>> fetchUserMushrooms(String userId) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  QuerySnapshot querySnapshot = await firestore
      .collection('mushrooms')
      .where('userID', isEqualTo: userId)
      .get();

  return querySnapshot.docs.map((doc) => Mushroom.fromFirestore(doc)).toList();
}

Stream<List<Mushroom>> streamUserMushrooms(String userId) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  return firestore
      .collection('mushrooms')
      .where('userID', isEqualTo: userId)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Mushroom.fromFirestore(doc)).toList());
}
