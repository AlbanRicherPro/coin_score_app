import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'new_game_page.dart';
import 'game_state.dart';
import 'game_state_storage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GameState? _savedGameState;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _checkSavedGameState();
  }

  Future<void> _checkSavedGameState() async {
    final loaded = await GameStateStorage.load();
    if (loaded != null && !loaded.endGame) {
      setState(() {
        _savedGameState = loaded;
        _loading = false;
      });
    } else {
      setState(() {
        _savedGameState = null;
        _loading = false;
      });
    }
  }

  void _resumeGame() {
    if (_savedGameState != null) {
      Navigator.of(context).pushNamed(
        '/new_game',
        arguments: _savedGameState!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xff4b9fc6),
      appBar: AppBar(
        backgroundColor: const Color(0xff4b9fc6),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            color: Colors.white,
            tooltip: 'Aide',
            onPressed: () {
              Navigator.of(context).pushNamed('/help');
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : FractionallySizedBox(
              alignment: Alignment.topCenter,
              heightFactor: 0.7, // Adjust this value for more/less top spacing
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/splash.png',
                      width: screenWidth * 0.65,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: screenHeight * 0.1),
                    if (_savedGameState != null && !_savedGameState!.endGame)
                      SizedBox(
                        width: 220,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            elevation: 8,
                          ),
                          onPressed: _resumeGame,
                          child: const Text('Reprendre la partie'),
                        ),
                      ),
                    SizedBox(height: 24),
                    SizedBox(
                      width: 220,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xff4b9fc6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          elevation: 8,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              transitionDuration: const Duration(milliseconds: 700),
                              pageBuilder: (context, animation, secondaryAnimation) => const NewGamePage(),
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
                            ),
                          );
                        },
                        child: const Text('Nouvelle partie'),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: 220,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xff4b9fc6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          elevation: 8,
                        ),
                        onPressed: () {
                          if (Theme.of(context).platform == TargetPlatform.iOS) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CupertinoAlertDialog(
                                  content: const Text('Bientôt disponible...'),
                                  actions: [
                                    CupertinoDialogAction(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: const Text('Bientôt disponible...'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: const Text('Historique'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
