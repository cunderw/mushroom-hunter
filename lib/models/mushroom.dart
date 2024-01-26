import 'package:my_mushrooms_hunter/models/geolocation.dart';

class Mushroom {
  String name;
  String description;
  GeoPoint
      geolocation; // Assuming GeoPoint is a class that stores latitude and longitude
  String photoUrl;
  DateTime dateAdded;

  Mushroom({
    required this.name,
    required this.description,
    required this.geolocation,
    required this.photoUrl,
    required this.dateAdded,
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
      'dateAdded': dateAdded.toIso8601String(),
    };
  }

  // Creates a Mushroom instance from a Map
  factory Mushroom.fromMap(Map<String, dynamic> map) {
    return Mushroom(
      name: map['name'],
      description: map['description'],
      geolocation: GeoPoint(
          map['geolocation']['latitude'], map['geolocation']['longitude']),
      photoUrl: map['photoUrl'],
      dateAdded: DateTime.parse(map['dateAdded']),
    );
  }
}
