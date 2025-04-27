import 'package:coin_score_app/player_state.dart';

// Callback type for change notification
typedef GameStateChanged = void Function(GameState);

class GameState {
  final List<PlayerState> _players;
  int _initialPoints;
  int _mode;
  int _round;
  bool _endGame;

  // Callback to notify when a change occurs
  final GameStateChanged? onChanged;

  GameState({
    required List<PlayerState> players,
    required int initialPoints,
    int mode = 0,
    int round = 1,
    bool endGame = false,
    this.onChanged,
  }) : _players = players,
       _initialPoints = initialPoints,
       _mode = mode,
       _round = round,
       _endGame = endGame;

  // Getters
  List<PlayerState> get players => _players;
  int get initialPoints => _initialPoints;
  int get mode => _mode;
  int get round => _round;
  bool get endGame => _endGame;

  // Setters with change notification
  set initialPoints(int value) {
    _initialPoints = value;
    _notifyChanged();
  }

  set mode(int value) {
    _mode = value;
    _notifyChanged();
  }

  set round(int value) {
    _round = value;
    _notifyChanged();
  }

  set endGame(bool value) {
    _endGame = value;
    _notifyChanged();
  }

  void _notifyChanged() {
    if (onChanged != null) {
      onChanged!(this);
    }
  }

  Map<String, dynamic> toJson() => {
    'players': _players.map((p) => p.toJson()).toList(),
    'initialPoints': _initialPoints,
    'mode': _mode,
    'round': _round,
    'endGame': _endGame,
  };

  factory GameState.fromJson(Map<String, dynamic> json) => GameState(
    players:
        (json['players'] as List)
            .map((p) => PlayerState.fromJson(Map<String, dynamic>.from(p)))
            .toList(),
    initialPoints: json['initialPoints'] ?? 150,
    mode: json['mode'] ?? 0,
    round: json['round'] ?? 1,
    endGame: json['endGame'] ?? false,
  );
}
