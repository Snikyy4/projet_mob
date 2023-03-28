import 'dart:math';

import 'package:flutter/material.dart';
import 'package:projet_mob/main.dart';

class FlagsScreen extends StatefulWidget {
  @override
  _FlagsScreenState createState() => _FlagsScreenState();
}

class _FlagsScreenState extends State<FlagsScreen> {
  final List<Flag> _flags = [
    Flag(name: 'France', image: 'lib/assets/france.png'),
    Flag(name: 'Allemagne', image: 'lib/assets/allemagne.png'),
    Flag(name: 'Italie', image: 'lib/assets/italie.png'),
    Flag(name: 'Espagne', image: 'lib/assets/espagne.png'),
  ];
  Flag? _currentFlag;
  String _inputValue = '';
  Set<Flag> _usedFlags = {};

  @override
  void initState() {
    super.initState();
    _currentFlag = _flags[0];
  }

  void _onGuess(String guess) {
  if (_currentFlag != null && guess.toLowerCase() == _currentFlag!.name.toLowerCase()) {
    final oldFlagName = _currentFlag!.name;
    _usedFlags.add(_currentFlag!);
    setState(() {
      if (_usedFlags.length == _flags.length) {
        _usedFlags.clear();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Fin du jeu!'),
              content: const Text('Vous avez terminé le jeu!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    navigateTo(context, const ChallengeScreen());
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        int randomIndex;
        do {
          randomIndex = Random().nextInt(_flags.length);
        } while (_usedFlags.contains(_flags[randomIndex]));
        _currentFlag = _flags[randomIndex];
        _inputValue = '';
      }
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Bravo!'),
          content: Text('Vous avez deviné le drapeau $oldFlagName'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Continuer'),
            ),
          ],
        );
      },
    );
  } else {
     _usedFlags.add(_currentFlag!);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Incorrect'),
          content: Text('La réponse est incorrecte.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  int randomIndex;
                  do {
                    randomIndex = Random().nextInt(_flags.length);
                  } while (_usedFlags.contains(_flags[randomIndex]));
                  _currentFlag = _flags[randomIndex];
                  _inputValue = '';
                });
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jeu des drapeaux'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              _currentFlag!.image,
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            TextField(
              onChanged: (value) {
                _inputValue = value;
              },
              onSubmitted: _onGuess,
              decoration: const InputDecoration(
                hintText: 'Entrez le nom du pays',
              ),
              controller: TextEditingController(text: _inputValue), // utiliser un controller pour afficher la valeur actuelle de _inputValue dans le champ de texte
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class Flag {
 

  final String name;
  final String image;

  Flag({required this.name, required this.image});
}
