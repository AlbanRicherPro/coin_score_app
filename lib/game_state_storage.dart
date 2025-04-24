import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'game_state.dart';

class GameStateStorage {
  static const String _key = 'current_game_state';

  static Future<void> save(GameState gameState) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(gameState.toJson());
    await prefs.setString(_key, jsonString);
  }

  static Future<GameState?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return null;
    final jsonData = jsonDecode(jsonString);
    return GameState.fromJson(jsonData);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
