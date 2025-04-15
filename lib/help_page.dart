import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aide'),
        backgroundColor: const Color(0xff4b9fc6),
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xffeaf6fb),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            'Bienvenue dans la page d\'aide!\n\n'
            'Expliquez ici les règles du jeu, les fonctionnalités de l\'application, '
            'ou toute information utile pour l\'utilisateur.',
            style: TextStyle(fontSize: 18, color: Color(0xff4b9fc6)),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
