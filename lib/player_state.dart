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

  Map<String, dynamic> toJson() => {
        'round': round,
        'finisher': finisher,
        'winRound': winRound,
        'currentPoint': currentPoint,
        'roundPoint': roundPoint,
      };

  factory PlayerRoundHistoryEntry.fromJson(Map<String, dynamic> json) => PlayerRoundHistoryEntry(
        round: json['round'] ?? 1,
        finisher: json['finisher'] ?? false,
        winRound: json['winRound'] ?? false,
        currentPoint: json['currentPoint'] ?? 0,
        roundPoint: json['roundPoint'] ?? 0,
      );
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

  Map<String, dynamic> toJson() => {
        'name': name,
        'points': points,
        'selectedCards': selectedCards.map((c) => c.toJson()).toList(),
        'roundHistory': roundHistory.map((r) => r.toJson()).toList(),
      };

  factory PlayerState.fromJson(Map<String, dynamic> json) => PlayerState(
        name: json['name'] ?? '',
        points: json['points'] ?? 0,
        selectedCards: (json['selectedCards'] as List?)?.map((c) => GameCardModel.fromJson(Map<String, dynamic>.from(c))).toList() ?? [],
        roundHistory: (json['roundHistory'] as List?)?.map((r) => PlayerRoundHistoryEntry.fromJson(Map<String, dynamic>.from(r))).toList() ?? [],
      );
}
