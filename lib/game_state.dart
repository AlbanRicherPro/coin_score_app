import 'package:coin_score_app/player_state.dart';

class GameState {
  final List<PlayerState> players;
  int initialPoints;
  int mode;

  GameState({
    required this.players,
    required this.initialPoints,
    required this.mode,
  });
}
