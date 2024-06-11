import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:my_mushrooms_hunter/models/mushroom.dart';

abstract class MushroomProvider {
  Future<void> saveMushroom(XFile image, String name, String description,
      LatLng geolocation, DateTime dateFound);
  Future<void> updateMushroom(Mushroom mushroom);
  Future<void> deleteMushroom(String id);
  Stream<List<Mushroom>> userMushrooms();
  Stream<List<Mushroom>> mushroomsNearLocation(
      double lat, double lng, double radius);
}

class FirestoreMushroomProvider implements MushroomProvider {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;
  final logger = Logger();
  final geo = GeoFlutterFire();

  CollectionReference get collection => firestore.collection('mushrooms');

  final String userID;

  FirestoreMushroomProvider(
      {required this.firestore, required this.storage, required this.userID}) {}

  Future<String> uploadImage(XFile image) async {
    final storagePath =
        'images/${userID}/${DateTime.now().millisecondsSinceEpoch}';
    final ref = storage.ref().child(storagePath);
    final uploadTask = ref.putFile(File(image.path));
    final snapshot = await uploadTask.whenComplete(() {});
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  @override
  Future<void> saveMushroom(XFile image, String name, String description,
      LatLng geolocation, DateTime dateFound) async {
    final documentRef = collection.doc();

    final photoUrl = await uploadImage(image);
    final mushroom = Mushroom(
      name: name,
      description: description,
      geolocation: geolocation,
      photoUrl: photoUrl,
      dateFound: dateFound,
    );
    await documentRef.set(mushroom.toFirestoreMap(userID)).catchError((error) {
      logger.e("Failed to add mushroom: $error");
      throw Exception('Failed to add mushroom');
    });
  }

  @override
  Future<void> updateMushroom(Mushroom mushroom) async {
    final documentRef = collection.doc(mushroom.id);

    try {
      await documentRef.update(mushroom.toFirestoreMap(userID));
      logger.i("Mushroom updated: ${mushroom.id}");
    } catch (error) {
      logger.e("Failed to update mushroom: $error");
      throw Exception('Failed to update mushroom');
    }
  }

  @override
  Future<void> deleteMushroom(String id) async {
    final documentRef = collection.doc(id);

    await documentRef.delete().catchError((error) {
      logger.e("Failed to delete mushroom: $error");
    });
  }

  @override
  Stream<List<Mushroom>> userMushrooms() {
    final collectionRef = collection
        .where('userID', isEqualTo: userID)
        .orderBy('dateFound', descending: true);
    return geo.collection(collectionRef: collectionRef).snapshot()!.map(
        (snapshot) =>
            snapshot.docs.map((doc) => Mushroom.fromFirestore(doc)).toList());
  }

  Stream<List<Mushroom>> mushroomsNearLocation(
      double lat, double lng, double radius) {
    // Create a geoFirePoint
    GeoFirePoint center = geo.point(latitude: lat, longitude: lng);

    return geo
        .collection(collectionRef: collection)
        .within(
            center: center,
            radius: radius,
            field: 'geolocation',
            strictMode: true)
        .map((snapshot) =>
            snapshot.map((doc) => Mushroom.fromFirestore(doc)).toList());
  }
}
