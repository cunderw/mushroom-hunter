import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Mushroom {
  String? id;
  String name;
  String description;
  LatLng
      geolocation; // Assuming GeoPoint is a class that stores latitude and longitude
  String photoUrl;
  DateTime dateFound;

  Mushroom({
    this.id,
    required this.name,
    required this.description,
    required this.geolocation,
    required this.photoUrl,
    required this.dateFound,
  });

  // Converts a Mushroom instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'geolocation': {
        'latitude': geolocation.latitude,
        'longitude': geolocation.longitude
      },
      'photoUrl': photoUrl,
      'dateFound': dateFound.toIso8601String(),
    };
  }

  // Creates a Mushroom instance from a Map
  factory Mushroom.fromMap(Map<String, dynamic> map) {
    return Mushroom(
      name: map['name'],
      description: map['description'],
      geolocation: LatLng(
          map['geolocation']['latitude'], map['geolocation']['longitude']),
      photoUrl: map['photoUrl'],
      dateFound: DateTime.parse(map['dateFound']),
    );
  }

  factory Mushroom.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;

    return Mushroom(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      geolocation: LatLng(
          data['geolocation']['latitude'], data['geolocation']['longitude']),
      photoUrl: data['photoUrl'] ?? '',
      dateFound: (data['dateFound'] as Timestamp).toDate(),
    );
  }
}
