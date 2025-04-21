import 'package:flutter/material.dart';

class GameCard extends StatelessWidget {
  final int number;
  final VoidCallback? onTap;
  final bool isSelected;

  const GameCard({Key? key, required this.number, this.onTap, this.isSelected = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        splashColor: Colors.amber.withValues(alpha: 0.2),
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        child: Ink(
          width: 48,
          height: 64,
          decoration: BoxDecoration(
            color: isSelected ? Colors.amber : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black26, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              number.toString(),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
