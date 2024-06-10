import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_mushrooms_hunter/data/mushroom_provider.dart';
import 'package:my_mushrooms_hunter/widgets/mushroom_form.dart';

class MockMushroomProvider extends Mock implements MushroomProvider {}

void main() {
  group('MushroomForm Widget Tests', () {
    late MockMushroomProvider mockMushroomProvider;

    final nameField = find.ancestor(
      of: find.text('Name'),
      matching: find.byType(TextFormField),
    );

    final descriptionField = find.ancestor(
      of: find.text('Description'),
      matching: find.byType(TextFormField),
    );

    // final dateField = find.ancestor(
    //   of: find.text('Date Found'),
    //   matching: find.byType(TextFormField),
    // );

    // final locationField = find.ancestor(
    //   of: find.text('Location Found'),
    //   matching: find.byType(TextFormField),
    // );

    final submitButton = find.ancestor(
      of: find.text('Submit'),
      matching: find.byType(ElevatedButton),
    );

    setUp(() {
      mockMushroomProvider = MockMushroomProvider();
    });

    testWidgets('Name field validation works', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: MushroomForm(mushroomProvider: mockMushroomProvider),
      ));
      await tester.ensureVisible(submitButton);
      await tester.pumpAndSettle();

      await tester.tap(submitButton);
      await tester.pumpAndSettle();
      expect(find.text('Please enter the mushroom name.'), findsOneWidget);

      await tester.enterText(nameField, 'Mushroom Name');
      await tester.pumpAndSettle();
      expect(find.text('Please enter the mushroom name.'), findsNothing);
    });

    testWidgets('Description field validation works',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: MushroomForm(mushroomProvider: mockMushroomProvider),
      ));
      await tester.ensureVisible(submitButton);
      await tester.pumpAndSettle();

      await tester.tap(submitButton);
      await tester.pumpAndSettle();
      expect(find.text('Please enter a description.'), findsOneWidget);

      await tester.enterText(descriptionField, 'Mushroom Description');
      await tester.pumpAndSettle();
      expect(find.text('Please enter a description.'), findsNothing);
    });

    testWidgets('Date field validation works', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: MushroomForm(mushroomProvider: mockMushroomProvider),
      ));
      final dateField = find.byKey(Key('_dateKey'));
      final okButton = find.text('OK');
      final currentDate = DateTime.now();
      await tester.ensureVisible(submitButton);
      await tester.pumpAndSettle();

      await tester.tap(submitButton);
      await tester.pumpAndSettle();
      expect(find.text('Please select a date.'), findsOneWidget);

      await tester.tap(dateField);
      await tester.pump();
      expect(
          find.byWidgetPredicate((widget) => widget is Dialog), findsOneWidget);

      // Close the date picker
      await tester.tap(okButton);
      await tester.pumpAndSettle();

      expect(
          find.byWidgetPredicate((widget) => widget is Dialog), findsNothing);

      expect(
          find.text(currentDate.toIso8601String().split('T').first), findsOne);
    });

    testWidgets('Location field validation works', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: MushroomForm(mushroomProvider: mockMushroomProvider),
      ));
      await tester.ensureVisible(submitButton);
      await tester.pumpAndSettle();

      await tester.tap(submitButton);
      await tester.pumpAndSettle();
      expect(find.text('Please select a location.'), findsOneWidget);
    });

    testWidgets('Image field validation works', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: MushroomForm(mushroomProvider: mockMushroomProvider),
      ));
      await tester.ensureVisible(submitButton);
      await tester.pumpAndSettle();

      // Tap the submit button
      await tester.tap(submitButton);
      await tester.pumpAndSettle();
      expect(find.text('Please select an image'), findsOneWidget);
    });
  });
}
