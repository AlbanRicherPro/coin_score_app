class GameState {
  final List<String> playerNames;
  final List<int> playerPoints;
  int chosenPoint;
  int mode;
  // Add more fields as needed (e.g., selectedIndex, etc.)

  GameState({
    required this.playerNames,
    required this.playerPoints,
    required this.chosenPoint,
    required this.mode
    // Add other fields here
  });

  GameState copyWith({
    List<String>? playerNames,
    List<int>? playerPoints,
    int? chosenPoint,
    int? mode
  }) {
    return GameState(
      playerNames: playerNames ?? this.playerNames,
      playerPoints: playerPoints ?? this.playerPoints,
      chosenPoint: chosenPoint ?? this.chosenPoint,
      mode: mode ?? this.mode
    );
  }
}
