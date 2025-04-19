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
      body: Padding(
        padding: const EdgeInsets.only(
          left: 0,
          right: 24.0,
          top: 16,
          bottom: 0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selected cards row (displayed at the top)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Wrap(
                spacing: 8,
                children: selectedCards.isEmpty ? [const SizedBox(width: 48, height: 64)] : selectedCards
                    .map((cardNum) => GameCard(number: cardNum, onTap: null, isSelected: false))
                    .toList(),
              ),
            ),
            const SizedBox(height: 8),
            // Game cards row (1-10)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Wrap(
                spacing: 8,
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
            ),
            const SizedBox(height: 8),
            // Existing payer names list
            Expanded(
              child: ListView.builder(
                itemCount: widget.gameState.players.length,
                padding: const EdgeInsets.only(bottom: 16),
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    alignment: Alignment.centerLeft,
                    child: ChoiceChip(
                      label: SizedBox(
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
                      selected: selectedIndex == index,
                      selectedColor: Colors.white,
                      backgroundColor: Colors.grey.shade400,
                      labelStyle: TextStyle(
                        color: selectedIndex == index ? const Color(0xff4b9fc6) : Colors.white,
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
          ],
        ),
      ),
    );
  }
}
