import 'package:coin_score_app/rounds_history_page.dart';
import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'my_home_page.dart'; // Assuming MyHomePage is defined in my_home_page.dart
import 'help_page.dart';
import 'new_game_page.dart'; // Assuming NewGamePage is defined in new_game_page.dart
import 'player_names_page.dart';
import 'player_points_page.dart';
import 'game_state.dart';
import 'end_game_page.dart';

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
            builder = (context) {
              final args = settings.arguments;
              if (args is GameState) {
                return NewGamePage(gameState: args);
              }
              return const NewGamePage();
            };
            break;
          case '/player_names':
            builder = (context) {
              final args = settings.arguments;
              if (args is GameState) {
                return PlayerNamesPage(gameState: args);
              }
              // fallback: show error or default page
              return const Scaffold(
                body: Center(child: Text('Erreur: état du jeu manquant')),
              );
            };
            break;
          case '/player_points':
            builder = (context) {
              final args = settings.arguments;
              if (args is GameState) {
                return PlayerPointsPage(gameState: args);
              } else {
                // fallback: show error or default page
                return const Scaffold(
                  body: Center(child: Text('Erreur: état du jeu manquant')),
                );
              }
            };
            break;
          case '/end_game':
            builder = (context) {
              final args = settings.arguments;
              if (args is GameState) {
                return EndGamePage(gameState: args);
              } else {
                return const Scaffold(
                  body: Center(child: Text('Erreur: état du jeu manquant')),
                );
              }
            };
            break;
          case '/game_history':
            builder = (context) {
              final args = settings.arguments;
              if (args is GameState) {
                return RoundsHistoryPage(gameState: args);
              } else {
                return const Scaffold(
                  body: Center(child: Text('Erreur: état du jeu manquant')),
                );
              }
            };
            break;
          default:
            builder =
                (context) =>
                    const Scaffold(body: Center(child: Text('Page not found')));
        }
        return PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) => builder(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutCubic,
            );
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
