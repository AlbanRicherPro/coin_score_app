import 'package:flutter/material.dart';
import 'game_state.dart';

class PlayerPointsPage extends StatefulWidget {
  final GameState gameState;

  const PlayerPointsPage({super.key, required this.gameState});

  @override
  _PlayerPointsPageState createState() => _PlayerPointsPageState();
}

class _PlayerPointsPageState extends State<PlayerPointsPage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff4b9fc6),
      appBar: AppBar(
        backgroundColor: const Color(0xff4b9fc6),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Scores',
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
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: widget.gameState.playerNames.length,
                padding: const EdgeInsets.only(bottom: 16),
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    alignment: Alignment.centerLeft,
                    child: ChoiceChip(
                      label: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: 50,
                          maxWidth: selectedIndex == index ? double.infinity : 50,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.gameState.playerNames[index],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.gameState.playerPoints[index].toString(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: selectedIndex == index ? const Color(0xff4b9fc6) : Colors.white,
                              ),
                            ),
                          ],
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
