import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_mushrooms_hunter/models/mushroom.dart';
import 'package:my_mushrooms_hunter/widgets/mushroom_card.dart';

void main() {
  group("MushroomCard Widget Tests", () {
    testWidgets('MushroomCard displays mushroom data correctly',
        (WidgetTester tester) async {
      final mushroom = Mushroom(
        id: '1',
        name: 'Mushroom 1',
        description: 'A beautiful mushroom.',
        photoUrl: 'https://example.com/photo.jpg',
        dateFound: DateTime(2023, 1, 1),
        geolocation: LatLng(0, 0),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MushroomCard(mushroom: mushroom),
          ),
        ),
      );

      expect(find.text('Mushroom 1'), findsOneWidget);
      expect(find.text('A beautiful mushroom.'), findsOneWidget);
      expect(find.text('2023-01-01'), findsOneWidget);
      expect(find.byType(CachedNetworkImage), findsOneWidget);
    });

    testWidgets('MushroomCard shows placeholder when image is loading',
        (WidgetTester tester) async {
      final mushroom = Mushroom(
        id: '1',
        name: 'Mushroom 1',
        description: 'A beautiful mushroom.',
        photoUrl: 'https://example.com/photo.jpg',
        dateFound: DateTime(2023, 1, 1),
        geolocation: LatLng(0, 0),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MushroomCard(mushroom: mushroom),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
