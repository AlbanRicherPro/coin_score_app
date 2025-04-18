import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'my_home_page.dart'; // Assuming MyHomePage is defined in my_home_page.dart
import 'help_page.dart';
import 'new_game_page.dart'; // Assuming NewGamePage is defined in new_game_page.dart
import 'player_names_page.dart';
import 'player_points_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coin Score App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff4b9fc6)),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case '/':
            builder = (context) => const SplashScreen();
            break;
          case '/home':
            builder = (context) => const MyHomePage();
            break;
          case '/help':
            builder = (context) => const HelpPage();
            break;
          case '/new_game':
            builder = (context) => const NewGamePage();
            break;
          case '/player_names':
            final args = settings.arguments as Map<String, dynamic>?;
            final int numPlayers = args != null && args['numPlayers'] != null ? args['numPlayers'] as int : 4;
            builder = (context) => PlayerNamesPage(numPlayers: numPlayers);
            break;
          case '/player_points':
            final args = settings.arguments as Map<String, dynamic>?;
            final playerNames = (args?['playerNames'] as List<dynamic>?)?.cast<String>() ?? [];
            final playerPoints = (args?['playerPoints'] as List<dynamic>?)?.cast<int>() ?? [];
            builder = (context) => PlayerPointsPage(
              playerNames: playerNames,
              playerPoints: playerPoints,
            );
            break;
          default:
            builder = (context) => const Scaffold(
              body: Center(child: Text('Page not found')),
            );
        }
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => builder(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curved = CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic);
            return FadeTransition(
              opacity: curved,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.98, end: 1.0).animate(curved),
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 700),
          settings: settings,
        );
      },
    );
  }
}
