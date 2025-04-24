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

  Map<String, dynamic> toJson() => {
        'players': players.map((p) => p.toJson()).toList(),
        'initialPoints': initialPoints,
        'mode': mode,
        'round': round,
        'endGame': endGame,
      };

  factory GameState.fromJson(Map<String, dynamic> json) => GameState(
        players: (json['players'] as List)
            .map((p) => PlayerState.fromJson(Map<String, dynamic>.from(p)))
            .toList(),
        initialPoints: json['initialPoints'] ?? 150,
        mode: json['mode'] ?? 0,
        round: json['round'] ?? 1,
        endGame: json['endGame'] ?? false,
      );
}
