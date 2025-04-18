import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlayerNamesPage extends StatefulWidget {
  final int numPlayers;
  const PlayerNamesPage({Key? key, required this.numPlayers}) : super(key: key);

  @override
  State<PlayerNamesPage> createState() => _PlayerNamesPageState();
}

class _PlayerNamesPageState extends State<PlayerNamesPage> {
  late List<TextEditingController> _controllers;
  int _numPlayers = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _numPlayers = widget.numPlayers;
    _controllers = List.generate(
      widget.numPlayers,
      (index) => TextEditingController(),
    );
  }

  @override
  void dispose() {
    for (int i = 0; i < widget.numPlayers; i++) {
      _controllers[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xff4b9fc6);
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
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 16, bottom: 50),
              child: Column(
                children: [
                  Image.asset('assets/images/splash.png', height: 80),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: 40), // Prevents overlap with button
                        itemCount: _numPlayers + 1,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (index < _numPlayers)
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        margin: const EdgeInsets.only(left: 4, right: 4),
                                        child: Material(
                                          color: Colors.white,
                                          shape: const CircleBorder(),
                                          child: const Icon(Icons.person, color: Color(0xff4b9fc6)),
                                        ),
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                          controller: _controllers[index],
                                          autocorrect: false,
                                          textCapitalization: TextCapitalization.words,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            labelText: 'Joueur ${index + 1}',
                                            floatingLabelBehavior: FloatingLabelBehavior.never,
                                            labelStyle: const TextStyle(
                                              color: Color(0xff4b9fc6),
                                              fontWeight: FontWeight.w300,
                                              fontSize: 16,
                                              fontStyle: FontStyle.italic,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                          ),
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Color(0xff4b9fc6),
                                          ),
                                          validator: (value) {
                                            if (value == null || value.trim().isEmpty) {
                                              return 'Le nom est requis';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      Container(
                                        width: 40,
                                        height: 40,
                                        margin: const EdgeInsets.only(left: 4, right: 4),
                                        child: Material(
                                          color: Colors.white,
                                          shape: const CircleBorder(),
                                          child: IconButton(
                                            icon: const Icon(Icons.delete, color: Color(0xff4b9fc6)),
                                            tooltip: 'Effacer',
                                            onPressed: () {
                                              setState(() {
                                                _numPlayers -= 1;
                                                _controllers[index].dispose();
                                                _controllers.removeAt(index);
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                if (index == _numPlayers)
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 55,
                                        child: ElevatedButton.icon(
                                          icon: const Icon(
                                            Icons.person_add,
                                            color: Color(0xff4b9fc6),
                                          ),
                                          label: const Text(
                                            'Ajouter un joueur',
                                            style: TextStyle(
                                              color: Color(0xff4b9fc6),
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            foregroundColor: Color(0xff4b9fc6),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(30),
                                            ),
                                            side: const BorderSide(color: Color(0xff4b9fc6), width: 2),
                                            elevation: 4,
                                          ),
                                          onPressed: _numPlayers < 8 ? () {
                                            setState(() {
                                              _controllers.add(TextEditingController());
                                              _numPlayers += 1;
                                            });
                                          } : null,
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
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Continuer'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xff4b9fc6),
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
                      if (Theme.of(context).platform == TargetPlatform.iOS) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CupertinoAlertDialog(
                              content: const Text('Bientôt disponible...'),
                              actions: [
                                CupertinoDialogAction(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: const Text('Bientôt disponible...'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
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
