import 'package:coin_score_app/game_state.dart';
import 'package:coin_score_app/player_state.dart';
import 'package:flutter/material.dart';

class PlayerNamesPage extends StatefulWidget {
  final GameState gameState;
  const PlayerNamesPage({super.key, required this.gameState});

  @override
  State<PlayerNamesPage> createState() => _PlayerNamesPageState();
}

class _PlayerNamesPageState extends State<PlayerNamesPage> {
  late List<TextEditingController> _controllers;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isAutoForwarding = false;
  late GameState _gameState;

  @override
  void initState() {
    super.initState();
    _gameState = widget.gameState;
    _controllers = List.generate(
      _gameState.players.length,
      (index) => TextEditingController(text: _gameState.players[index].name),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_gameState.round > 1) {
        setState(() => _isAutoForwarding = true);
        Navigator.of(context)
            .pushNamed('/player_points', arguments: _gameState)
            .then((_) => setState(() => _isAutoForwarding = false));
      }
    });
  }

  @override
  void dispose() {
    for (int i = 0; i < _gameState.players.length; i++) {
      _controllers[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isAutoForwarding) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
        backgroundColor: Color(0xff4b9fc6),
      );
    }
    final primaryColor = const Color(0xff4b9fc6);
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Noms des joueurs',
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
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.topCenter,
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 24.0,
                right: 24.0,
                top: 16,
                bottom: 50,
              ),
              child: Column(
                children: [
                  Image.asset('assets/images/splash.png', height: 80),
                  SizedBox(height: screenHeight * 0.05),
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: ListView.builder(
                        padding: const EdgeInsets.only(
                          bottom: 40,
                        ), // Prevents overlap with button
                        itemCount: _gameState.players.length + 1,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (index < _gameState.players.length)
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        margin: const EdgeInsets.only(
                                          left: 4,
                                          right: 8,
                                        ),
                                        child: Material(
                                          color: Colors.white,
                                          shape: const CircleBorder(),
                                          child: Icon(
                                            Icons.person,
                                            color: primaryColor,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          key: Key('player${index + 1}_name'),
                                          autovalidateMode:
                                              AutovalidateMode
                                                  .onUserInteraction,
                                          controller: _controllers[index],
                                          autocorrect: false,
                                          textCapitalization:
                                              TextCapitalization.words,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            labelText: 'Joueur ${index + 1}',
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.never,
                                            labelStyle: TextStyle(
                                              color: primaryColor,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 16,
                                              fontStyle: FontStyle.italic,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              borderSide: BorderSide.none,
                                            ),
                                          ),
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: primaryColor,
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return 'Le nom est requis';
                                            }
                                            return null;
                                          },
                                          onChanged: (value) async {
                                            setState(() {
                                              _gameState.players[index].name =
                                                  value;
                                            });
                                            _gameState.onChanged?.call(
                                              _gameState,
                                            );
                                          },
                                        ),
                                      ),
                                      Container(
                                        width: 40,
                                        height: 40,
                                        margin: const EdgeInsets.only(
                                          left: 8,
                                          right: 4,
                                        ),
                                        child: Material(
                                          color: Colors.white,
                                          shape: const CircleBorder(),
                                          child: IconButton(
                                            key: Key('delete_player${index + 1}'),
                                            icon: Icon(
                                              Icons.delete,
                                              color: primaryColor,
                                            ),
                                            tooltip: 'Effacer',
                                            onPressed: () async {
                                              setState(() {
                                                _gameState.players.removeAt(
                                                  index,
                                                );
                                                _controllers[index].dispose();
                                                _controllers.removeAt(index);
                                              });
                                              _gameState.onChanged?.call(
                                                _gameState,
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                if (index == _gameState.players.length)
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 55,
                                        child: ElevatedButton.icon(
                                          icon: Icon(
                                            Icons.person_add,
                                            color: primaryColor,
                                          ),
                                          label: Text(
                                            'Ajouter un joueur',
                                            style: TextStyle(
                                              color: primaryColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            foregroundColor: primaryColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            side: BorderSide.none,
                                            elevation: 4,
                                          ),
                                          onPressed:
                                              _gameState.players.length < 8
                                                  ? () {
                                                    setState(() {
                                                      _controllers.add(
                                                        TextEditingController(),
                                                      );
                                                      _gameState.players.add(
                                                        PlayerState(
                                                          name: '',
                                                          points:
                                                              _gameState
                                                                  .initialPoints,
                                                        ),
                                                      );
                                                      _gameState.onChanged
                                                          ?.call(_gameState);
                                                    });
                                                  }
                                                  : null,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 16,
            child: SafeArea(
              top: true,
              left: true,
              right: true,
              bottom: true,
              minimum: EdgeInsets.zero,
              child: SizedBox(
                height: 60,
                child: ElevatedButton.icon(
                  key: const Key('continue_button'),
                  label: const Text('Continuer'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: primaryColor,
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
                    if (_formKey.currentState!.validate()) {
                      Navigator.of(context)
                          .pushNamed('/player_points', arguments: _gameState)
                          .then((_) async => {setState(() {})});
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
