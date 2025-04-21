import 'package:coin_score_app/player_state.dart';

class GameState {
  final List<PlayerState> players;
  int initialPoints;
  int mode;
  int round;

  GameState({
    required this.players,
    required this.initialPoints,
    required this.mode,
    required this.round,
  });
}
