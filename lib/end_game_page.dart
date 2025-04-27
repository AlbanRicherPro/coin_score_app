import 'package:coin_score_app/game_state_storage.dart';
import 'package:coin_score_app/player_state.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'game_state.dart';

class EndGamePage extends StatelessWidget {
  final GameState gameState;

  const EndGamePage({super.key, required this.gameState});

  @override
  Widget build(BuildContext context) {
    // Sort players by points ascending (lowest points is the winner)
    final playersSorted = [...gameState.players]
      ..sort((a, b) => a.points.compareTo(b.points));
    final winner = playersSorted.first;

    return Scaffold(
      backgroundColor: const Color(0xff4b9fc6),
      appBar: AppBar(
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Fin de la partie',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Winner's Lottie animation
            Lottie.asset(
              'assets/lottie/winner.json',
              width: 200,
              height: 200,
              repeat: false,
            ),
            Text(
              winner.name,
              style: const TextStyle(
                color: Colors.amber,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Classement :',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...playersSorted.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final player = entry.value;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Text(
                            '#${idx + 1}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              player.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Text(
                            '${player.points} pts',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Add a button to view the rounds history
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.history),
                style: ElevatedButton.styleFrom(
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
                label: const Text('Historique des manches'),
                onPressed: () {
                  Navigator.of(
                    context,
                  ).pushNamed('/game_history', arguments: gameState);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 8,
                textStyle: const TextStyle(
                  color: Color(0xff4b9fc6),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                padding: const EdgeInsets.symmetric(vertical: 18),
              ),
              onPressed: () async {
                await GameStateStorage.clear();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/new_game',
                  (route) => route.settings.name == '/home',
                  arguments: GameState(
                    players:
                        gameState.players
                            .map(
                              (player) => PlayerState(
                                name: player.name,
                                points: gameState.initialPoints,
                              ),
                            )
                            .toList(),
                    initialPoints: gameState.initialPoints,
                    mode: gameState.mode,
                    onChanged: (gs) => GameStateStorage.save(gs),
                  ),
                );
              },
              child: const Text('Nouvelle partie'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 8,
                textStyle: const TextStyle(
                  color: Color(0xff4b9fc6),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                padding: const EdgeInsets.symmetric(vertical: 18),
              ),
              onPressed: () async {
                await GameStateStorage.clear();
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/home', (route) => false);
              },
              child: const Text('Terminer'),
            ),
          ],
        ),
      ),
    );
  }
}
