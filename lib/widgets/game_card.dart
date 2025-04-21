import 'package:flutter/material.dart';
import '../models/game_card_model.dart';

class GameCard extends StatelessWidget {
  final GameCardModel card;
  final VoidCallback? onTap;
  final bool isSelected;

  const GameCard({super.key, required this.card, this.onTap, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        splashColor: Colors.amber.withValues(alpha: 0.2),
        highlightColor: Colors.amber.withValues(alpha: 0.2),
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        child: Ink(
          width: 48,
          height: 64,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: Center(
            child: Ink.image(
              image: card.icon.image,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
