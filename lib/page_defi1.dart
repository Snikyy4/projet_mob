import 'dart:math';

import 'package:flutter/material.dart';
import 'package:projet_mob/main.dart';
import 'challenge_screen.dart';

class FlagsScreen extends StatefulWidget {
  const FlagsScreen({Key? key}) : super(key: key);

  @override
  _FlagsScreenState createState() => _FlagsScreenState();
}

class _FlagsScreenState extends State<FlagsScreen> {
  final List<Flag> _flags = [
    Flag(name: 'France', image: 'lib/assets/pays/france.png'),
    Flag(name: 'Allemagne', image: 'lib/assets/pays/allemagne.png'),
    Flag(name: 'Italie', image: 'lib/assets/pays/italie.png'),
    Flag(name: 'Espagne', image: 'lib/assets/pays/espagne.png'),
    Flag(name: 'Royaume unis', image: 'lib/assets/pays/angleterre.png'),
    Flag(name: 'Argentine', image: 'lib/assets/pays/argentine.png'),
    Flag(name: 'Australie', image: 'lib/assets/pays/australie.png'),
   
    // Ajouter d'autres pays ici si nécessaire
  ];

  final int _numFlags = 5; // Nombre de drapeaux à deviner

  Flag? _currentFlag;
  String _inputValue = '';
  Set<Flag> _usedFlags = {};

  List<Flag> _selectFlags() {
    // Sélectionne _numFlags drapeaux aléatoirement parmi _flags
    List<Flag> selectedFlags = [];
    List<Flag> unusedFlags = List.from(_flags);
    Random random = Random();

    for (int i = 0; i < _numFlags; i++) {
      int index = random.nextInt(unusedFlags.length);
      selectedFlags.add(unusedFlags.removeAt(index));
    }

    return selectedFlags;
  }

  @override
  void initState() {
    super.initState();
    List<Flag> selectedFlags = _selectFlags();
    _currentFlag = selectedFlags[0];
    _flags.retainWhere((flag) => selectedFlags.contains(flag));
  }

  void _onGuess(String guess) {
  if (_currentFlag != null && guess.toLowerCase() == _currentFlag!.name.toLowerCase()) {
    final oldFlagName = _currentFlag!.name;
    _usedFlags.add(_currentFlag!);
    setState(() {
      if (_usedFlags.length == _numFlags) {
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
                    navigateTo(context, MyHomePage(pseudo: nom_user, nbVictoires: nb_victoires, tempsTaupe: temps_taupe));
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
          content: Text('Vous avez deviné le drapeau $oldFlagName.'),
          actions: [
            TextButton(
              onPressed:
 () {
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
    if (_usedFlags.length == _numFlags) {
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
                  navigateTo(context, MyHomePage(pseudo: nom_user, nbVictoires: nb_victoires, tempsTaupe: temps_taupe));
                },
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
            title: const Text('Incorrect'),
            content: const Text('La réponse est incorrecte.'),
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
