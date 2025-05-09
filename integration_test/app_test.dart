import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:coin_score_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  group('Coin Score App Integration Tests', () {
    // Test app launch and initial navigation
    testWidgets('App launches and navigates to home screen', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Check splash screen transitions to home
      expect(find.byKey(const Key('resume_game_button')), findsNothing);
      expect(find.byKey(const Key('new_game_button')), findsOneWidget);
      expect(find.byKey(const Key('history_button')), findsOneWidget);
    });

    // Test creating a new game
    testWidgets('Create a new game with players', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Tap on New Game button
      await tester.tap(find.byKey(const Key('new_game_button')));
      await tester.pumpAndSettle();

      // configure game
      expect(find.text('Nouvelle partie'), findsOneWidget);
      expect(find.byKey(const Key('continue_button')), findsOneWidget);
      await tester.tap(find.byKey(const Key('continue_button')));
      await tester.pumpAndSettle();

      // Enter player names
      expect(find.text('Noms des joueurs'), findsOneWidget);
      expect(find.byKey(const Key('continue_button')), findsOneWidget);
      expect(find.byKey(const Key('player1_name')), findsOneWidget);
      await tester.enterText(find.byKey(const Key('player1_name')), 'Alice');
      expect(find.byKey(const Key('player2_name')), findsOneWidget);
      await tester.enterText(find.byKey(const Key('player2_name')), 'Bob');

      await tester.tap(find.byKey(const Key('continue_button')));
      await tester.pumpAndSettle();

      // Verify error messages for player 3 and 4
      expect(find.byKey(const Key('player3_name')), findsOneWidget);
      expect(find.byKey(const Key('player4_name')), findsOneWidget);
      expect(find.text('Le nom est requis'), findsNWidgets(2));

      expect(find.byKey(const Key('delete_player3')), findsOneWidget);
      await tester.tap(find.byKey(const Key('delete_player3')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('player3_name')), findsOneWidget);
      expect(find.byKey(const Key('player4_name')), findsNothing);
      expect(find.text('Le nom est requis'), findsOneWidget);

      expect(find.byKey(const Key('delete_player3')), findsOneWidget);
      await tester.tap(find.byKey(const Key('delete_player3')));
      await tester.pumpAndSettle();

      expect(find.text('Le nom est requis'), findsNothing);

      await tester.tap(find.byKey(const Key('continue_button')));
      await tester.pumpAndSettle();

      expect(find.text('Manche 1'), findsOneWidget);
    });

    // Test help page navigation
    testWidgets('Navigate to Help page', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Tap Help button
      await tester.tap(find.byIcon(Icons.help_outline));
      await tester.pumpAndSettle();

      // Verify Help page content
      expect(find.text('Aide'), findsOneWidget);
    });
  });
}
