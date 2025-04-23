import 'package:coin_score_app/game_state.dart';
import 'package:flutter/material.dart';

class RoundsHistoryPage extends StatelessWidget {
  final GameState gameState;

  const RoundsHistoryPage({super.key, required this.gameState});

  @override
  Widget build(BuildContext context) {
    // Determine the max number of rounds played (could differ if undo was used)
    int maxRounds = gameState.players
        .map((p) => p.roundHistory.length)
        .fold(0, (a, b) => a > b ? a : b);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique des manches'),
        backgroundColor: const Color(0xff4b9fc6),
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xffeaf6fb),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: constraints.maxWidth,
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(const Color(0xff4b9fc6)),
                headingTextStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                columnSpacing: 8,
                columns: [
                  const DataColumn(label: Text('Manche'), headingRowAlignment: MainAxisAlignment.center),
                  ...gameState.players.map((p) => DataColumn(label: Text(p.name), headingRowAlignment: MainAxisAlignment.center)),
                ],
                rows: [
                  DataRow(
                    cells: [
                      DataCell(Center(child: Text('0'))),
                      ...gameState.players.map(
                        (_) => DataCell(
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('${gameState.initialPoints}'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  ...List.generate(maxRounds, (i) {
                    return DataRow(
                      cells: [
                        DataCell(Center(child: Text((i + 1).toString()))),
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
                                      Icons.flag,
                                      color: Color(0xff4b9fc6),
                                      size: 18,
                                    ),
                                  if (!isFinisher) const SizedBox(width: 18),
      
                                  const SizedBox(width: 4),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            roundPoint.toString(),
                                            style: TextStyle(
                                              color:
                                                  entry.winRound
                                                      ? Colors.green
                                                      : Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            currentPoint.toString(),
                                            style: TextStyle(
                                              fontWeight:
                                                  isFinisher
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
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
