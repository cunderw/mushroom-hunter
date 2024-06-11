import 'package:flutter_test/flutter_test.dart';
import 'package:my_mushrooms_hunter/models/mushroom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

void main() {
  group('Mushroom', () {
    final mushroom = Mushroom(
      id: '123',
      name: 'Amanita',
      description: 'A poisonous mushroom.',
      geolocation: LatLng(40.7128, -74.0060),
      photoUrl: 'http://example.com/photo.jpg',
      dateFound: DateTime(2023, 5, 22),
    );

    test('toFirestoreMap should convert Mushroom instance to a Firestore Map',
        () {
      final userID = 'user_123';
      final map = mushroom.toFirestoreMap(userID);

      expect(map['userID'], userID);
      expect(map['name'], mushroom.name);
      expect(map['description'], mushroom.description);
      expect((map['geolocation'])['geopoint'].latitude,
          mushroom.geolocation.latitude);
      expect((map['geolocation'])['geopoint'].longitude,
          mushroom.geolocation.longitude);
      expect(map['photoUrl'], mushroom.photoUrl);
      expect((map['dateFound'] as Timestamp).toDate(), mushroom.dateFound);
    });

    test(
        'fromFirestore should create a Mushroom instance from a Firestore DocumentSnapshot',
        () async {
      final firestore = FakeFirebaseFirestore();

      final map = {
        'name': 'Amanita',
        'description': 'A poisonous mushroom.',
        'geolocation': {
          'geopoint': GeoPoint(40.7128, -74.0060),
        },
        'photoUrl': 'http://example.com/photo.jpg',
        'dateFound': Timestamp.fromDate(DateTime(2023, 5, 22)),
      };

      final docRef = await firestore.collection('mushrooms').add(map);
      final snapshot = await docRef.get();

      final newMushroom = Mushroom.fromFirestore(snapshot);

      expect(newMushroom.id, docRef.id);
      expect(newMushroom.name, mushroom.name);
      expect(newMushroom.description, mushroom.description);
      expect(newMushroom.geolocation.latitude, mushroom.geolocation.latitude);
      expect(newMushroom.geolocation.longitude, mushroom.geolocation.longitude);
      expect(newMushroom.photoUrl, mushroom.photoUrl);
      expect(newMushroom.dateFound, mushroom.dateFound);
    });
  });
}
