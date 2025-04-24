class GameCardModel {
  final int points;
  final String name;

  GameCardModel({required this.points, required this.name});

  Map<String, dynamic> toJson() => {
        'points': points,
        'name': name,
      };

  factory GameCardModel.fromJson(Map<String, dynamic> json) => GameCardModel(
        points: json['points'] ?? 0,
        name: json['name'] ?? '',
      );
}
