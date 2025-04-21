import 'models/game_card_model.dart';

class PlayerState {
  String name;
  int points;
  List<GameCardModel> selectedCards;

  PlayerState({required this.name, required this.points, List<GameCardModel>? selectedCards})
      : selectedCards = selectedCards ?? [];
}
