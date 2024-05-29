import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:mockito/mockito.dart';
import 'package:my_mushrooms_hunter/data/mushroom_provider.dart';
import 'package:my_mushrooms_hunter/models/mushroom.dart';

class MockLogger extends Mock implements Logger {}

void main() {
  group('FirestoreMushroomProvider', () {
    late FakeFirebaseFirestore fakeFirestore;
    late MockFirebaseStorage mockStorage;
    late FirestoreMushroomProvider provider;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      mockStorage = MockFirebaseStorage();
      provider = FirestoreMushroomProvider(
        firestore: fakeFirestore,
        storage: mockStorage,
        userID: 'test_user',
      );
    });

    test('saveMushroom should save a mushroom to Firestore', () async {
      final filePath = 'test_resources/test_image.jpg';
      final XFile image = XFile(filePath);

      await provider.saveMushroom(
        image,
        'Shiitake',
        'A type of mushroom',
        LatLng(35.6895, 139.6917),
        DateTime.now(),
      );

      final snapshot = await fakeFirestore.collection('mushrooms').get();
      expect(snapshot.docs.length, 1);
      final savedMushroom = snapshot.docs.first.data();

      expect(savedMushroom['name'], 'Shiitake');
      expect(savedMushroom['description'], 'A type of mushroom');
      expect(savedMushroom['userID'], 'test_user');
    });

    test('updateMushroom should update a mushroom in Firestore', () async {
      final documentRef =
          fakeFirestore.collection('mushrooms').doc('test_mushroom');
      final mushroom = Mushroom(
        id: 'test_mushroom',
        name: 'Shiitake',
        description: 'A type of mushroom',
        geolocation: LatLng(35.6895, 139.6917),
        photoUrl: 'https://example.com/test_image.jpg',
        dateFound: DateTime.now(),
      );

      await documentRef.set(mushroom.toFirestoreMap('test_user'));

      final updatedMushroom = Mushroom(
        id: 'test_mushroom',
        name: 'Updated Shiitake',
        description: 'A type of mushroom',
        geolocation: LatLng(35.6895, 139.6917),
        photoUrl: 'https://example.com/test_image.jpg',
        dateFound: DateTime.now(),
      );

      await provider.updateMushroom(updatedMushroom);

      final snapshot = await documentRef.get();
      final data = snapshot.data() as Map<String, dynamic>;

      expect(data['name'], 'Updated Shiitake');
    });

    test('deleteMushroom should delete a mushroom from Firestore', () async {
      final documentRef =
          fakeFirestore.collection('mushrooms').doc('test_mushroom');
      final mushroom = Mushroom(
        id: 'test_mushroom',
        name: 'Shiitake',
        description: 'A type of mushroom',
        geolocation: LatLng(35.6895, 139.6917),
        photoUrl: 'https://example.com/test_image.jpg',
        dateFound: DateTime.now(),
      );

      await documentRef.set(mushroom.toFirestoreMap('test_user'));

      await provider.deleteMushroom('test_mushroom');

      final snapshot = await documentRef.get();
      expect(snapshot.exists, false);
    });

    test('userMushrooms should stream list of mushrooms', () async {
      final documentRef =
          fakeFirestore.collection('mushrooms').doc('test_mushroom');
      final mushroom = Mushroom(
        id: 'test_mushroom',
        name: 'Shiitake',
        description: 'A type of mushroom',
        geolocation: LatLng(35.6895, 139.6917),
        photoUrl: 'https://example.com/test_image.jpg',
        dateFound: DateTime.now(),
      );

      await documentRef.set(mushroom.toFirestoreMap('test_user'));

      final stream = provider.userMushrooms();
      final mushrooms = await stream.first;

      expect(mushrooms.length, 1);
      expect(mushrooms.first.name, 'Shiitake');
    });
  });
}
