import 'package:flutter/material.dart';
import 'game_state.dart';
import 'widgets/game_card.dart';
import 'widgets/defiling_text.dart';

class PlayerPointsPage extends StatefulWidget {
  final GameState gameState;

  const PlayerPointsPage({super.key, required this.gameState});

  @override
  _PlayerPointsPageState createState() => _PlayerPointsPageState();
}

class _PlayerPointsPageState extends State<PlayerPointsPage> {
  int selectedIndex = 0;
  int round = 1;

  // Add state for selected cards
  List<int> selectedCards = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff4b9fc6),
      appBar: AppBar(
        backgroundColor: const Color(0xff4b9fc6),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Manche $round',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            color: Colors.white,
            tooltip: 'Aide',
            onPressed: () {
              Navigator.of(context).pushNamed('/help');
            },
          ),
        ],
      ),
      body: Column(
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
                    if (selectedCards.isNotEmpty)
                      Expanded(
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          alignment: WrapAlignment.center,
                          children:
                              selectedCards
                                  .map(
                                    (cardNum) => SizedBox(
                                      width: 60,
                                      height: 76,
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          Center(
                                            child: GameCard(
                                              number: cardNum,
                                              isSelected: true,
                                            ),
                                          ),
                                          Positioned(
                                            top: 0,
                                            right: 0,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selectedCards.remove(cardNum);
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
                            selectedCards.isEmpty
                                ? '0'
                                : selectedCards
                                    .reduce((value, element) => value + element)
                                    .toString(),
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
          // Main content row: player names and available cards
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 24.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Player names list with fixed width
                  SizedBox(
                    width: 135,
                    child: ListView.builder(
                      itemCount: widget.gameState.players.length,
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
                                    text: widget.gameState.players[index].name,
                                    enabled: selectedIndex == index,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '${widget.gameState.players[index].points} pts',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color:
                                        selectedIndex == index
                                            ? const Color(0xff4b9fc6)
                                            : Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            selected: selectedIndex == index,
                            selectedColor: Colors.white,
                            backgroundColor: Colors.grey.shade400,
                            labelStyle: TextStyle(
                              color:
                                  selectedIndex == index
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
                                selectedIndex = index;
                              });
                            },
                            elevation: 8,
                            shadowColor: Colors.black.withAlpha(15),
                          ),
                        );
                      },
                    ),
                  ),
                  // Cards panel takes remaining width
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Cartes disponibles',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            alignment: WrapAlignment.center,
                            children: List.generate(10, (i) {
                              int cardNum = i + 1;
                              return GameCard(
                                number: cardNum,
                                onTap: () {
                                  setState(() {
                                    selectedCards.add(cardNum);
                                  });
                                },
                                isSelected: false,
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
