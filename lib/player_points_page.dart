import 'dart:math';

import 'package:coin_score_app/player_state.dart';
import 'package:coin_score_app/game_state.dart';
import 'package:flutter/material.dart';
import 'widgets/game_card.dart';
import 'widgets/defiling_text.dart';
import 'models/game_card_model.dart';
import 'package:lottie/lottie.dart';

class PlayerPointsPage extends StatefulWidget {
  final GameState gameState;

  const PlayerPointsPage({super.key, required this.gameState});

  @override
  State<PlayerPointsPage> createState() => _PlayerPointsPageState();
}

class _PlayerPointsPageState extends State<PlayerPointsPage> {
  int _selectedIndex = 0;
  bool _showOverlay = false;
  bool _isSelectedPlayerWinRound = false;
  PlayerState? _playerFinishingTheRound;
  late GameState _gameState;

  @override
  void initState() {
    super.initState();
    _gameState = widget.gameState;
  }

  @override
  Widget build(BuildContext context) {
    // Get selected cards for the current player
    final currentPlayer = _gameState.players[_selectedIndex];
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xff4b9fc6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Manche ${_gameState.round}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          if (_gameState.round > 1)
            IconButton(
              icon: const Icon(Icons.history),
              color: Colors.white,
              tooltip: 'Manche précédente',
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Annuler la manche ?',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Voulez-vous vraiment annuler la manche actuelle et revenir à la précédente ?',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey.shade300,
                                  foregroundColor: Colors.black,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Non'),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff4b9fc6),
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () {
                                  _previousRound();
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Oui'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            color: Colors.white,
            tooltip: 'Aide',
            onPressed: () {
              Navigator.of(context).pushNamed('/help', arguments: _gameState);
            },
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.topCenter,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Selected cards section with label
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 24.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Points du joueur sélectionné',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (currentPlayer.selectedCards.isNotEmpty)
                          Expanded(
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              alignment: WrapAlignment.center,
                              children:
                                  currentPlayer.selectedCards
                                      .map(
                                        (cardObj) => SizedBox(
                                          width: 60,
                                          height: 76,
                                          child: Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              Center(
                                                child: GameCard(
                                                  card: cardObj,
                                                  isSelected: true,
                                                ),
                                              ),
                                              Positioned(
                                                top: 0,
                                                right: 0,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      currentPlayer
                                                          .selectedCards
                                                          .remove(cardObj);
                                                    });
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      shape: BoxShape.circle,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black26,
                                                          blurRadius: 2,
                                                        ),
                                                      ],
                                                    ),
                                                    padding: EdgeInsets.all(2),
                                                    child: Icon(
                                                      Icons.close,
                                                      size: 16,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                      .toList(),
                            ),
                          ),
                        SizedBox(
                          width: 70,
                          height: 76,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                currentPlayer.selectedPoints.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  SizedBox(width: 150),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Cartes disponibles',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              // Main content row: player names and available cards
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 24.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Player names list with fixed width
                      SizedBox(
                        width: 150,
                        child: ListView.builder(
                          itemCount: _gameState.players.length,
                          padding: const EdgeInsets.only(bottom: 16),
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              alignment: Alignment.centerLeft,
                              child: ChoiceChip(
                                label: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      child: DefilingText(
                                        text: _gameState.players[index].name,
                                        enabled: _selectedIndex == index,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text(
                                          '${_gameState.players[index].points} pts',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                _selectedIndex == index
                                                    ? const Color(0xff4b9fc6)
                                                    : Colors.white,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              '${_gameState.players[index].selectedPoints}',
                                              style: TextStyle(
                                                fontSize: 20,
                                                color:
                                                    _selectedIndex == index
                                                        ? const Color(
                                                          0xff4b9fc6,
                                                        )
                                                        : Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                selected: _selectedIndex == index,
                                selectedColor: Colors.white,
                                backgroundColor: Colors.grey.shade400,
                                labelStyle: TextStyle(
                                  color:
                                      _selectedIndex == index
                                          ? const Color(0xff4b9fc6)
                                          : Colors.white,
                                ),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                ),
                                showCheckmark: false,
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedIndex = index;
                                  });
                                },
                                elevation: 8,
                                shadowColor: Colors.black.withAlpha(15),
                              ),
                            );
                          },
                        ),
                      ),
                      // Available cards
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            alignment: WrapAlignment.center,
                            children: List.generate(10, (i) {
                              int cardNum = i + 1;
                              String cardName = cardNum.toString();
                              return GameCard(
                                card: GameCardModel(
                                  points: cardNum,
                                  name: cardName,
                                ),
                                onTap: () {
                                  setState(() {
                                    currentPlayer.selectedCards.add(
                                      GameCardModel(
                                        points: cardNum,
                                        name: cardName,
                                      ),
                                    );
                                  });
                                },
                                isSelected: false,
                              );
                            }),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // --- Manche suivante button (bottom of page, like other pages) ---
          Positioned(
            left: 24,
            right: 24,
            bottom: 16,
            child: SafeArea(
              top: false,
              left: true,
              right: true,
              bottom: true,
              minimum: EdgeInsets.zero,
              child: SizedBox(
                height: 60,
                child: ElevatedButton.icon(
                  label: const Text(
                    'Manche suivante',
                    style: TextStyle(
                      color: Color(0xff4b9fc6),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 8,
                    textStyle: const TextStyle(
                      color: Color(0xff4b9fc6),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () async {
                    final selected = await showModalBottomSheet<PlayerState>(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                      ),
                      isScrollControlled: true,
                      builder: (context) {
                        return SafeArea(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 16),
                              const Text(
                                'Qui a osé couiner ?',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ...List.generate(
                                _gameState.players.length,
                                (idx) => ListTile(
                                  title: Center(
                                    child: Text(_gameState.players[idx].name),
                                  ),
                                  onTap:
                                      () => Navigator.of(
                                        context,
                                      ).pop(_gameState.players[idx]),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        );
                      },
                    );
                    if (selected != null) {
                      _onNextRoundPlayerTap(selected);
                    }
                  },
                ),
              ),
            ),
          ),
          // Overlay plein écran animé
          if (_showOverlay)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.8),
                child: Center(
                  child:
                      _isSelectedPlayerWinRound == true
                          ? Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Lottie.asset(
                                'assets/lottie/success.json',
                                width: min(screenWidth, screenHeight) * 0.8,
                                height: min(screenWidth, screenHeight) * 0.8,
                                repeat: false,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                ),
                                child: Text(
                                  'Jolie couinade ${_playerFinishingTheRound?.name} !',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          )
                          : Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Lottie.asset(
                                'assets/lottie/failure.json',
                                width: min(screenWidth, screenHeight) * 0.8,
                                height: min(screenWidth, screenHeight) * 0.8,
                                repeat: false,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                ),
                                child: Text(
                                  'Dommage ${_playerFinishingTheRound?.name} ! Couinade ratée !',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _onNextRoundPlayerTap(PlayerState finisher) async {
    setState(() {
      _playerFinishingTheRound = finisher;
      // First, mutate points
      if (finisher != _findPlayerWithLowerPoints()) {
        _isSelectedPlayerWinRound = false;
        finisher.points -= _findBiggestPoints();
      } else {
        _isSelectedPlayerWinRound = true;
        for (var player in _gameState.players) {
          if (finisher != player) {
            player.points -= player.selectedPoints;
          }
        }
      }
      // Now, save round history for each player AFTER mutating points
      for (var player in _gameState.players) {
        player.roundHistory.add(
          PlayerRoundHistoryEntry(
            round: _gameState.round,
            finisher: player == finisher,
            winRound:
                (player == finisher && _isSelectedPlayerWinRound) ||
                (player != finisher && !_isSelectedPlayerWinRound),
            currentPoint: player.points,
            roundPoint: player.selectedPoints,
          ),
        );
      }
      for (var player in _gameState.players) {
        player.selectedCards.clear();
        if (player.points <= 0) {
          _gameState.endGame = true;
        }
      }
      _showOverlay = true;
    });
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showOverlay = false;
          _playerFinishingTheRound = null;
          _selectedIndex = 0;
          if (_gameState.endGame) {
            _endGame();
          } else {
            _gameState.round += 1;
          }
        });
      }
    });
  }

  void _previousRound() async {
    setState(() {
      for (var player in _gameState.players) {
        if (player.roundHistory.isNotEmpty) {
          var last = player.roundHistory.removeLast();
          player.points = last.currentPoint;
          player.selectedCards.clear();
        }
      }
      _gameState.round = _gameState.round > 1 ? _gameState.round - 1 : 1;
    });
  }

  void _endGame() async {
    await Navigator.of(context).pushNamed('/end_game', arguments: _gameState);
    _previousRound();
  }

  PlayerState _findPlayerWithLowerPoints() {
    return _gameState.players.reduce(
      (a, b) => a.selectedPoints < b.selectedPoints ? a : b,
    );
  }

  int _findBiggestPoints() {
    return _gameState.players
        .reduce((a, b) => a.selectedPoints > b.selectedPoints ? a : b)
        .selectedPoints;
  }
}
