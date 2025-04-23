import 'models/game_card_model.dart';

class PlayerRoundHistoryEntry {
  final int round;
  final bool finisher;
  final bool winRound;
  final int currentPoint;
  final int roundPoint;

  PlayerRoundHistoryEntry({
    required this.round,
    required this.finisher,
    required this.winRound,
    required this.currentPoint,
    required this.roundPoint,
  });
}

class PlayerState {
  String name;
  int points;
  List<GameCardModel> selectedCards;
  List<PlayerRoundHistoryEntry> roundHistory;

  PlayerState({required this.name, required this.points, List<GameCardModel>? selectedCards, List<PlayerRoundHistoryEntry>? roundHistory})
      : selectedCards = selectedCards ?? [],
        roundHistory = roundHistory ?? [];

  int get selectedPoints => selectedCards.isNotEmpty ? selectedCards.map((c) => c.points).reduce((a, b) => a + b) : 0;
}
