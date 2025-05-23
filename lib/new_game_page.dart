import 'package:coin_score_app/player_state.dart';
import 'package:flutter/material.dart';
import 'modern_number_input.dart';
import 'modern_switch.dart';
import 'game_state.dart';
import 'game_state_storage.dart';

class NewGamePage extends StatefulWidget {
  final GameState? gameState;
  const NewGamePage({super.key, this.gameState});

  @override
  State<NewGamePage> createState() => _NewGamePageState();
}

class _NewGamePageState extends State<NewGamePage> {
  late GameState _gameState;
  bool _isAutoForwarding = false;

  @override
  void initState() {
    super.initState();
    _gameState =
        widget.gameState ??
        GameState(
          players: List.generate(
            4,
            (index) => PlayerState(name: '', points: 150),
            growable: true,
          ),
          initialPoints: 150,
          onChanged: (gs) => GameStateStorage.save(gs),
        );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_gameState.round > 1) {
        setState(() => _isAutoForwarding = true);
        Navigator.of(context)
            .pushNamed('/player_names', arguments: _gameState)
            .then((_) => setState(() => _isAutoForwarding = false));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isAutoForwarding) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
        backgroundColor: Color(0xff4b9fc6),
      );
    }
    final primaryColor = const Color(0xff4b9fc6);
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Nouvelle partie',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.help_outline),
            tooltip: 'Aide',
            onPressed: () {
              Navigator.of(context).pushNamed('/help');
            },
          ),
        ],
        centerTitle: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.topCenter,
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 24.0,
                right: 24.0,
                top: 16,
                bottom: 50,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/images/splash.png', height: 80),
                  SizedBox(height: screenHeight * 0.05),
                  ModernNumberInput(
                    label: 'Nombre de joueurs',
                    value: _gameState.players.length,
                    min: 2,
                    max: 8,
                    step: 1,
                    onChanged:
                        (v) => setState(() {
                          if (v < _gameState.players.length) {
                            _gameState.players.removeLast();
                          } else {
                            _gameState.players.add(
                              PlayerState(
                                name: '',
                                points: _gameState.initialPoints,
                              ),
                            );
                          }
                        }),
                    primaryColor: primaryColor,
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  ModernNumberInput(
                    label: 'Capital de départ (points)',
                    value: _gameState.initialPoints,
                    min: 10,
                    max: 1000,
                    step: 10,
                    onChanged:
                        (v) => setState(() {
                          _gameState.initialPoints = v;
                          for (var player in _gameState.players) {
                            player.points = v;
                          }
                        }),
                    primaryColor: primaryColor,
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  ModernSwitch(
                    label: 'Mode de jeu',
                    options: const ['PIOU PIOU', 'ULTRA'],
                    selectedIndex: _gameState.mode,
                    onChanged: (idx) => setState(() => _gameState.mode = idx),
                    primaryColor: primaryColor,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 16,
            child: SafeArea(
              top: true,
              left: true,
              right: true,
              bottom: true,
              minimum: EdgeInsets.zero,
              child: SizedBox(
                height: 60,
                child: ElevatedButton.icon(
                  key: const Key('continue_button'),
                  label: const Text('Continuer'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: primaryColor,
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
                    Navigator.of(context)
                        .pushNamed('/player_names', arguments: _gameState)
                        .then((_) async => {setState(() {})});
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
