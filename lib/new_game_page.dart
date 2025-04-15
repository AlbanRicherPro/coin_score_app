import 'package:flutter/material.dart';
import 'modern_number_input.dart';
import 'modern_switch.dart';

class NewGamePage extends StatefulWidget {
  const NewGamePage({super.key});

  @override
  State<NewGamePage> createState() => _NewGamePageState();
}

class _NewGamePageState extends State<NewGamePage> {
  int numPlayers = 4;
  int initialBank = 150;
  int modeIndex = 0; // 0: PIOU PIOU, 1: ULTRA

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xff4b9fc6);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.home),
          tooltip: 'Accueil',
          onPressed: () {
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil('/home', (route) => false);
          },
        ),
        title: const Text(
          'Nouvelle partie',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.help_outline),
            tooltip: 'Aide',
            onPressed: () {
              Navigator.of(context).pushNamed('/help');
            },
          ),
        ],
        centerTitle: true,
      ),
      body: FractionallySizedBox(
        alignment: Alignment.topCenter,
        heightFactor: 1,
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo + Title
              Image.asset(
                'assets/images/splash.png',
                width: screenWidth * 0.65,
                fit: BoxFit.contain,
              ),
              SizedBox(height: screenHeight * 0.05),
              ModernNumberInput(
                label: 'Nombre de joueurs',
                value: numPlayers,
                min: 2,
                max: 8,
                step: 1,
                onChanged: (v) => setState(() => numPlayers = v),
                primaryColor: primaryColor,
              ),
              const SizedBox(height: 32),
              ModernNumberInput(
                label: 'Capital de départ (points)',
                value: initialBank,
                min: 10,
                max: 1000,
                step: 10,
                onChanged: (v) => setState(() => initialBank = v),
                primaryColor: primaryColor,
              ),
              const SizedBox(height: 32),
              // Mode slider
              ModernSwitch(
                label: 'Mode de jeu',
                options: const ['PIOU PIOU', 'ULTRA'],
                selectedIndex: modeIndex,
                onChanged: (idx) => setState(() => modeIndex = idx),
                primaryColor: primaryColor,
              ),
              SizedBox(height: screenHeight * 0.1),
              SizedBox(
                width: 220,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    elevation: 8,
                  ),
                  onPressed: () {
                    // TODO: Continue to next step
                  },
                  child: const Text('Continuer'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
