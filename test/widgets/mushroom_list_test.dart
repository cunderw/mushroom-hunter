import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:my_mushrooms_hunter/models/mushroom.dart';
import 'package:my_mushrooms_hunter/data/mushroom_provider.dart';
import 'package:my_mushrooms_hunter/widgets/mushroom_card.dart';
import 'package:my_mushrooms_hunter/widgets/mushroom_list.dart';
import 'package:mockito/mockito.dart';

import 'mushroom_list_test.mocks.dart';

@GenerateMocks([MushroomProvider])
void main() {
  group('MushroomList Widget Tests', () {
    late MockMushroomProvider mockMushroomProvider;

    setUp(() {
      mockMushroomProvider = MockMushroomProvider();
      when(mockMushroomProvider.userMushrooms())
          .thenAnswer((_) => Stream<List<Mushroom>>.empty());
    });

    Widget createMushroomList() {
      return MaterialApp(
        home: Scaffold(
          body: MushroomList(mushroomProvider: mockMushroomProvider),
        ),
      );
    }

    testWidgets('Displays loading indicator when waiting for data',
        (WidgetTester tester) async {
      when(mockMushroomProvider.userMushrooms())
          .thenAnswer((_) => Stream<List<Mushroom>>.empty());

      await tester.pumpWidget(createMushroomList());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Displays error message on error', (WidgetTester tester) async {
      when(mockMushroomProvider.userMushrooms())
          .thenAnswer((_) => Stream<List<Mushroom>>.error('Error'));

      await tester.pumpWidget(createMushroomList());
      await tester.pump();

      expect(find.text('Error: Error'), findsOneWidget);
    });

    testWidgets('Displays "No mushrooms found" when there are no mushrooms',
        (WidgetTester tester) async {
      when(mockMushroomProvider.userMushrooms())
          .thenAnswer((_) => Stream<List<Mushroom>>.value([]));

      await tester.pumpWidget(createMushroomList());
      await tester.pump();

      expect(find.text('No mushrooms found'), findsOneWidget);
    });

    testWidgets('Displays mushroom list when there are mushrooms',
        (WidgetTester tester) async {
      final mushrooms = [
        Mushroom(
            id: '1',
            name: 'Mushroom 1',
            description: 'Description 1',
            geolocation: LatLng(0, 0),
            photoUrl: '',
            dateFound: DateTime.now()),
        Mushroom(
            id: '2',
            name: 'Mushroom 2',
            description: 'Description 2',
            geolocation: LatLng(0, 0),
            photoUrl: '',
            dateFound: DateTime.now()),
      ];

      when(mockMushroomProvider.userMushrooms())
          .thenAnswer((_) => Stream<List<Mushroom>>.value(mushrooms));

      await tester.pumpWidget(createMushroomList());
      await tester.pump();

      expect(find.byType(MushroomCard), findsNWidgets(2));
    });

    testWidgets('Deletes a mushroom on swipe', (WidgetTester tester) async {
      final mushrooms = [
        Mushroom(
            id: '1',
            name: 'Mushroom 1',
            description: 'Description 1',
            geolocation: LatLng(0, 0),
            photoUrl: '',
            dateFound: DateTime.now()),
      ];

      when(mockMushroomProvider.userMushrooms())
          .thenAnswer((_) => Stream<List<Mushroom>>.value(mushrooms));

      await tester.pumpWidget(createMushroomList());
      await tester.pump();

      expect(find.byType(MushroomCard), findsOneWidget);

      // Perform swipe gesture
      await tester.drag(find.byType(MushroomCard), Offset(-500.0, 0.0));
      await tester.pumpAndSettle();

      verify(mockMushroomProvider.deleteMushroom('1')).called(1);
      expect(find.text('Mushroom deleted'), findsOneWidget);
    });
  });
}
