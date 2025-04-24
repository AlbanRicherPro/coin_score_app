import 'package:coin_score_app/game_state.dart';
import 'package:coin_score_app/player_state.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class RoundsHistoryPage extends StatelessWidget {
  final GameState gameState;

  const RoundsHistoryPage({super.key, required this.gameState});

  @override
  Widget build(BuildContext context) {
    // Determine the max number of rounds played (could differ if undo was used)
    int maxRounds = gameState.players
        .map((p) => p.roundHistory.length)
        .fold(0, (a, b) => a > b ? a : b);
    PlayerState winner = gameState.players.reduce(
      (p1, p2) => p1.points < p2.points ? p1 : p2,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique',style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),),
        backgroundColor: const Color(0xff4b9fc6),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: const Color(0xffeaf6fb),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: constraints.maxWidth,
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(
                  const Color(0xff4b9fc6),
                ),
                headingTextStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                columnSpacing: 8,
                columns: [
                  const DataColumn(
                    label: Text('Manche'),
                    headingRowAlignment: MainAxisAlignment.center,
                  ),
                  ...gameState.players.map(
                    (p) => DataColumn(
                      label: Row(
                        children: [
                          if (p == winner)
                            const Icon(
                              Symbols.rewarded_ads,
                              color: Colors.white,
                              size: 18,
                            ),
                          Text(p.name),
                        ],
                      ),
                      headingRowAlignment: MainAxisAlignment.center,
                    ),
                  ),
                ],
                rows: [
                  DataRow(
                    cells: [
                      DataCell(
                        Center(
                          child: Text(
                            '#0',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      ...gameState.players.map(
                        (_) => DataCell(
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '${gameState.initialPoints}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  ...List.generate(maxRounds, (i) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Center(
                            child: Text(
                              '#${i + 1}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        ...gameState.players.map((player) {
                          if (player.roundHistory.length > i) {
                            final entry = player.roundHistory[i];
                            final isFinisher = entry.finisher;
                            final currentPoint = entry.currentPoint;
                            final roundPoint = entry.roundPoint;

                            return DataCell(
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if (isFinisher)
                                    const Icon(
                                      Symbols.sports_score,
                                      color: Color(0xff4b9fc6),
                                      size: 18,
                                    ),
                                  if (!isFinisher) const SizedBox(width: 18),

                                  const SizedBox(width: 4),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            roundPoint.toString(),
                                            style: TextStyle(
                                              color:
                                                  entry.winRound
                                                      ? Color(0xff4b9fc6)
                                                      : Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            currentPoint.toString(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 22),
                                ],
                              ),
                            );
                          } else {
                            return const DataCell(Text('-'));
                          }
                        }),
                      ],
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
