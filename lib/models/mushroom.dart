import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Mushroom {
  String? id;
  String name;
  String description;
  LatLng
      geolocation; // Assuming GeoPoint is a class that stores latitude and longitude
  String photoUrl;
  DateTime dateFound;
  final geo = GeoFlutterFire();

  Mushroom({
    this.id,
    required this.name,
    required this.description,
    required this.geolocation,
    required this.photoUrl,
    required this.dateFound,
  });

  // Converts a Mushroom instance to a Map
  Map<String, dynamic> toFirestoreMap(String userID) {
    return {
      'userID': userID,
      'name': name,
      'description': description,
      'geolocation': geo
          .point(
              latitude: geolocation.latitude, longitude: geolocation.longitude)
          .data,
      'photoUrl': photoUrl,
      'dateFound': Timestamp.fromDate(dateFound),
    };
  }

  factory Mushroom.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map;
    final geopoint = data['geolocation']['geopoint'] as GeoPoint;

    return Mushroom(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      geolocation: LatLng(geopoint.latitude, geopoint.longitude),
      photoUrl: data['photoUrl'] ?? '',
      dateFound: (data['dateFound'] as Timestamp).toDate(),
    );
  }
}
