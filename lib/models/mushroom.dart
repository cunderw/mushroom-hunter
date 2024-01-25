import 'package:my_mushrooms_hunter/models/geolocation.dart';

class Mushroom {
  String name;
  String description;
  GeoPoint
      geolocation; // Assuming GeoPoint is a class that stores latitude and longitude
  String photoUrl;

  Mushroom({
    required this.name,
    required this.description,
    required this.geolocation,
    required this.photoUrl,
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
    );
  }
}
