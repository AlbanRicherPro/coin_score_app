import 'package:coin_score_app/player_state.dart';

class GameState {
  final List<PlayerState> players;
  int initialPoints;
  int mode;
  int round;
  bool endGame;

  GameState({
    required this.players,
    required this.initialPoints,
    this.mode = 0,
    this.round = 1,
    this.endGame = false,
  });
}
